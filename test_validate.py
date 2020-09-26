import requests
import sys
requests.packages.urllib3.disable_warnings()
x = requests.get('https://archiva.mpgsdev.mastercard.int/', verify=False)
#x = requests.get('http://repo.mpgsdev.mastercard.int', verify=False)

print("check - https://archiva.mpgsdev.mastercard.int/")
print (x.status_code)
if (x.status_code != 200):
  print("Fail")
  sys.exit("404 error")
  print("ssssssssss")
else:
  print("Pass")
