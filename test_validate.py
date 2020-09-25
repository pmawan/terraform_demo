import requests
requests.packages.urllib3.disable_warnings()
x = requests.get('https://jsdgcsjugudcvdf.com', verify=False)

print("check - https://https://jsdgcsjugudcvdf.com")
print (x.status_code)
if (x.status_code != 200):
  print("Fail")
else:
  print("Pass")


