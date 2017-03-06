#/bin/bash/

# This is so cron will run out this directory instead of /home/tocat/ so it can write to the log files with this directory.
cd /apps/rdsreplication/

now=test-db-$(date '+%Y-%m-%d-%H-%M')

# Creates DB snapshot
echo ---------------------------------------- >> create_snap.txt
echo Start time:  >> create_snap.txt
date >> create_snap.txt

aws rds create-db-snapshot --db-instance-identifier db --db-snapshot-identifier $now

while true; do
  STATUS=`aws rds describe-db-snapshots --db-snapshot-identifier $now | grep "Status" | awk '{print $2}' | sed 's/[",]//g'`
  if [ "$STATUS" == "available" ]; then
    break
  else
    echo "" &> /dev/null
  fi

  sleep 15

done

echo Completion time: >> create_snap.txt
date >> create_snap.txt
echo ---------------------------------------- >> create_snap.txt
echo "" >> create_snap.txt


# Copies DB snapshot from us-east1 to us-west-2
echo ---------------------------------------- >> copy_snap.txt
echo Start time: >> copy_snap.txt
date >> copy_snap.txt

aws rds copy-db-snapshot \
   --source-db-snapshot-identifier arn:aws:rds:us-east-1:ARN Number:snapshot:$now \
   --region us-west-2 \
   --target-db-snapshot-identifier $now \
   --source-region us-east-1\
   --kms-key-id destination region key ID

sleep 70

while true; do
  DRSTATUS=`aws rds describe-db-snapshots --region us-west-2 --db-snapshot-identifier $now | grep "Status" | awk '{print $2}' | sed 's/[",]//g'`
  if [ "$DRSTATUS" == "available" ]; then
    break
  else
    echo "" &> /dev/null
fi

  sleep 20

done

echo Completion time: >> copy_snap.txt
date >> copy_snap.txt
echo ---------------------------------------- >> copy_snap.txt
echo "" >> copy_snap.txt

echo "Snapshot creation and cross-region replication was successful!" | mail -s "RDS Snapshot cron ran successfully" Foo@Bar.com                                                                                                                                                                                  64,1          B
