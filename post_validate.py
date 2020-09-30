import requests
requests.packages.urllib3.disable_warnings()
x = requests.get('https://archiva.mpgsdev.mastercard.int/archiva/#welcome', verify=False)

print("check - https://archiva.mpgsdev.mastercard.int/archiva/#welcome ")
print (x.status_code)

##repo.mpgsdev.mastercard.int
x = requests.get('http://repo.mpgsdev.mastercard.int', verify=False)
print("check - https://repo.mpgsdev.mastercard.int")
#print(x.text)
print (x.status_code)

##repo.mpgsdev.mastercard.int
x = requests.get('https://kibana_vs', verify=False)
print("check - https://10.169.72.196/")
#print(x.text)
print (x.status_code)
