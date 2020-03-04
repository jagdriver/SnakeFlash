# Up until now, this script only handles type A records.
# More may come on request

import requests
import json
import sys

IP=sys.argv[1]

DOMAIN="YOUR_DOMAIN"
# looks like: domain.com
# no www

SUBDOMAIN="YOUR_SUBDOMAIN"
# looks like "play"
# NOT play.example.com

TIMEOUT=3600
#TTL

ID="DNS_ID_HERRE"
# You can find the DNS ID like this:
# In Firefox, Press F12 to open the Developer Console
# Select the Network tab
# Go to the dns page of one.com
# Change anything to one of the domains
# Click on the second element in the list in the console (counted from the button)
# You can identify it by the "PATCH" in the second column
# A window should pop up on the left
# At the very top it says "Request URL:"
# At the end of that domain, there should be a 8 Digit long number
# That is your ID
# Copy it into the variable above
# KEEP THE QUOTATION MARKS!!!

# CREDENTIALS
USERNAME="YOUR_EMAIL_HERE"
PASSWORD="YOUR_PASSWORD_HERE"




# INITIATE SESSION
session=requests.Session();

loginurl = "https://www.one.com/admin/login.do"

# CREATE DATA FOR LOGIN
logindata = {'loginDomain': True,'displayUsername': USERNAME, 'password1': PASSWORD, 'username': USERNAME, 'targetDomain': '', 'loginTarget': ''}
session.post(loginurl, data=logindata)

# CREATE DATA FOR DNS CHANGE

tosend = {"type":"dns_service_records","id":ID,"attributes":{"type":"A","prefix":SUBDOMAIN,"content":IP,"ttl":TIMEOUT}}

dnsurl="https://www.one.com/admin/api/domains/" + DOMAIN + "/dns/custom_records/" + ID
sendheaders={'Content-Type': 'application/json'}

# PATCH DATA
r2=session.patch(dnsurl, data=json.dumps(tosend), headers=sendheaders)


print(r2.text)
print(IP)