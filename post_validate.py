import requests
requests.packages.urllib3.disable_warnings()
x = requests.get('https://archiva.mpgsdev.mastercard.int/archiva/#welcome', verify=False)

print("check - https://archiva.mpgsdev.mastercard.int/archiva/#welcome ")
print (x.status_code)
if (x.status_code != 200):
  print("Fail")
  sys.exit("404 error")
else:
  print("Pass")

##repo.mpgsdev.mastercard.int
x = requests.get('http://repo.mpgsdev.mastercard.int', verify=False)
print("check - https://repo.mpgsdev.mastercard.int")
print (x.status_code)
if (x.status_code != 200):
  print("Fail")
  sys.exit("404 error")
else:
  print("Pass")

##kibana VS
x = requests.get('https://10.157.159.44:14443', verify=False)
print("check - https://kibana_vs/")
print (x.status_code)
if (x.status_code != 200):
  print("Fail")
  sys.exit("404 error")
else:
  print("Pass")
