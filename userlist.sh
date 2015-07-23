#!/bin/bash

NFS=/nfs/dust/cms/user/eren
INPUT_file=$(ls -ltrh $NFS/input | grep pnfs | awk '{print $9}')
cat $NFS/input/$INPUT_file | grep /user/ | awk -F/ '{print $8}' > user
cat $NFS/input/$INPUT_file | grep /user/ | awk -F'"' '{print $2}' > filename

paste user filename | awk '{print $1,$2}' | sort -n > $NFS/output_T2Users/user.files.txt

rm user
rm filename

exit 0;





