try: import xml.etree.ElementTree as ET
except ImportError: from elementtree import ElementTree as ET
try: import json
except ImportError: import simplejson as json
import urllib2, httplib, sys

with open('/nfs/dust/cms/user/eren/input/SiteDB.json') as f: users = f.read()
output_file = open('/nfs/dust/cms/user/eren/output_T2Users/SiteDB.output', 'w') 

users = json.loads(users)

#print json.dumps(users)
#print users[desc][eeren]

#for people in users.keys():
users_len = len(users['result'])
print users_len
for i in range(1,users_len):
	username = users['result'][i][0] 
	dn = users['result'][i][4]
	if ( username == "hn-cms-admin@cern.ch"):
		continue
	output_file.write(username + '\t' + dn)	
	output_file.write('\n')

output_file.close()
