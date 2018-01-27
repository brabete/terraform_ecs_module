#cloud-config
packages:
  - jq
  - python27-boto
  - aws-apitools-ec2
  - aws-cli
  - nfs-utils

users:
  - default

write_files:
  - content: |
        #!/bin/bash
        . /etc/ecs/ecs.config

        MOUNT=$${1:-/srv/data}
        mountpoint $MOUNT && exit -1
        DEVICE=/dev/xvdn

        if [ ! -f $DEVICE ]; then
          AZ=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
          REGION=`echo $AZ | sed -e 's#[a-z]$##'`
          export AWS_DEFAULT_REGION=$REGION

          ID=`curl -s http://169.254.169.254/latest/meta-data/instance-id`

          VOL_ID=0
          until [ "$VOL_ID" == "null" ]; do
            VOL_ID=`aws ec2 describe-volumes --filter "Name=tag:ClusterName,Values=$${ECS_CLUSTER}" "Name=availability-zone,Values=$AZ" "Name=status,Values=available" | jq -r '.Volumes[0].VolumeId'`
            aws ec2 attach-volume --volume-id $VOL_ID --instance-id $ID --device $DEVICE
            sleep 3
          done
        fi

        if [ "`file -b -s $DEVICE`" == "data" ]; then mkfs.ext4 $DEVICE; fi

        test -d $MOUNT || mkdir -p $MOUNT
        UUID=`blkid $DEVICE | awk -F \" '{print $2}'`
        grep "^$${UUID}" /etc/fstab || printf "UUID=%s %s ext4 noatime 0 0\n" $UUID $MOUNT | tee -a /etc/fstab
        mount $MOUNT
    path: /usr/local/sbin/mount_ebs.sh
    owner: root:root
    permissions: 0750

  - content: |
        start on (starting ecs)
        task
        exec /usr/local/sbin/mount_ebs.sh
    path: /etc/init/mount_ebs.conf
    owner: root:root
    permissions: 0644

bootcmd:
  - echo ECS_CLUSTER=${cluster_name} | tee /etc/ecs/ecs.config
  - echo ECS_ENGINE_TASK_CLEANUP_WAIT_DURATION=10m | tee -a /etc/ecs/ecs.config
  - echo ECS_IMAGE_CLEANUP_INTERVAL=10m | tee -a /etc/ecs/ecs.config
  - echo ECS_IMAGE_MINIMUM_CLEANUP_AGE=15m | tee -a /etc/ecs/ecs.config
  - echo ECS_NUM_IMAGES_DELETE_PER_CYCLE=10 | tee -a /etc/ecs/ecs.config
  - echo ECS_AVAILABLE_LOGGING_DRIVERS='["json-file", "awslogs", "splunk", "gelf"]' | tee -a /etc/ecs/ecs.config
  - if [ ! -z "${efs_storate_name}" ]; then test -d /srv/efs || mkdir -p /srv/efs && mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 ${efs_storate_name}:/ /srv/efs/ ; fi
