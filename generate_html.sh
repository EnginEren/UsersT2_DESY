#!/bin/bash

IFS=$'\n'
set -f
PBS=/nfs/dust/cms/user/eren

#comm -12 $1 $2 | awk '{print $1,$2}' > notouch
cat $PBS/output_T2Users/user.files_billing.txt | awk '{print $1,$2}' > notouch

cat $PBS/output_T2Users/user.files_billing.txt | awk '{print $1}' | sort -u > onlyname
cat /nfs/dust/cms/user/eren/output_T2Users/SiteDB.output | awk '{print $1}' | sort -u > cms_users


touch users.html

echo "<!DOCTYPE html>
<html>
<head>
<BODY BACKGROUND="speckle.gif"> 
<title>
Users@T2_DESY
</title>
</head>
<body>
<h2> Users who did not access/touch files in tier2/store/user directory over 12 months. </h2>
<h2> People who do not have DN mapping with CMS Site-Database have total amount of : </h2>
<img src="usergroup.png" alt="People" style="width:256px" align="right"> " > users.html
user_flag=false
for i in $(cat onlyname); do
	touch user_$i.html
	user_size=$(cat /nfs/dust/cms/user/eren/output_T2Users/user.files_billing_size.txt| grep $i | awk '{print $3}' | awk '{s+=$1} END {print s}' | awk '{print $1/1024^3}')
	echo "<!DOCTYPE html>
<html>
<body>
<BODY BACKGROUND="speckle.gif">
<h2>Dear $i, you did not access these files in tier2/store/user directory over 12 months. Size : $user_size GB </h2> " > user_$i.html
	cat cms_users | grep '\<'$i'\>' > /dev/null
	if [ "$?" == "1" ]; then
		user="$i"
		echo $user_size >> noncms
		echo "<ul>
		<li> <p><a href="https://eeren.web.cern.ch/eeren/user_$i.html"> $i (<font color="red">No DN mapping is found</font>)</a></p> </li> 
	        </ul>" >> users.html
	else
		user="$i"
		dn=$(cat /nfs/dust/cms/user/eren/output_T2Users/SiteDB.output | grep '\<'$i'\>' | awk '{print $2}') 
                echo "<ul>
                <li> <p><a href="https://eeren.web.cern.ch/eeren/user_$i.html"> $i ($dn)</a></p> </li>
                </ul>" >> users.html
	fi
        echo "<pre>" >> user_$i.html
	grep $i notouch | awk '{print $2}' >> user_$i.html
	echo "</pre>" >> user_$i.html
echo "</body>
</html>" >> user_$i.html


done

echo "</body>
</html>" >> users.html

rm notouch onlyname cms_users
echo "Now putting everything into lxplus..."
#scp *.html eeren@lxplus.cern.ch:~/www
#mv *.html
NONcms=$(cat noncms | awk '{print $1}' | awk '{s+=$1} END {print (s/1024)}')
Line_num=$(cat users.html | grep -n amount | awk '{print $1}' | cut -d : -f1)  
sed -i ''$Line_num's/.*/<h2> People who do not have DN mapping with CMS Site-Database have total '$NONcms' TB<\/h2>/' users.html

rm noncms

exit 0;
