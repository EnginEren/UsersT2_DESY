#!/bin/bash

NFS=/nfs/dust/cms/user/eren
INPUT_file=$(ls -ltrh $NFS/input | grep cms.transfer | awk '{print $9}')

cat $NFS/input/$INPUT_file | awk '{if ($10 == "0" && $7 !~ 2015) print $5}' | grep /user/ | awk -F/ '{print $8}' > user
cat $NFS/input/$INPUT_file | awk '{if ($10 == "0" && $7 !~ 2015) print $5}'  > filename
cat $NFS/input/$INPUT_file | awk '{if ($10 == "0" && $7 !~ 2015) print $3}'  > size

paste user filename | awk '{print $1,$2}' | sort -n > $NFS/output_T2Users//user.files_billing.txt
paste user filename size | awk '{print $1,$2,$3}' | sort -n > $NFS/output_T2Users/user.files_billing_size.txt

rm user
rm filename
rm size

exit 0;





