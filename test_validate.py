import requests
requests.packages.urllib3.disable_warnings()
x = requests.get('https://archiva.mpgsdev.mastercard.int/', verify=False)

print("check - https://archiva.mpgsdev.mastercard.int/")
print (x.status_code)
if (x.status_code != 200):
  print("Fail")
else:
  print("Pass")


