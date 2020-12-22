def pre_checks(bigip, url):
    ## validate status of VS and pool + members
    payload1 = {"command":"run", "utilCmdArgs": "-c 'tmsh save sys ucs ucs_bip0dev0_crq000123 passphrase test123'"}
    vs_config = bigip.post(url, json.dumps(payload1)).json()
    print (vs_config)
    time.sleep(5)



def get_token(bigip, url, creds):
    payload = {}
    payload['username'] = creds[0]
    payload['password'] = creds[1]
    payload['loginProviderName'] = 'tmos'

    token = bigip.post(url, json.dumps(payload)).json()['token']['token']
    return token


if __name__ == "__main__":
    import os, requests, json, argparse, getpass, time
    requests.packages.urllib3.disable_warnings()

    parser = argparse.ArgumentParser(description='Remote Authentication - KSC2STL')

    parser.add_argument("username", help='BIG-IP Username')
    parser.add_argument("password", help='BIG-IP password')
    args = vars(parser.parse_args())

    username = args['username']
    password = args['password']

    hostname = '10.157.159.44'
    url_base = 'https://%s/mgmt' % hostname
    url_auth = '%s/shared/authn/login' % url_base
    url_pool = '%s/tm/util/bash' % url_base


    b = requests.session()
    b.headers.update({'Content-Type':'application/json'})
    b.auth = (username, password)
    b.verify = False

    token = get_token(b, url_auth, (username, password))
    print ('\nToken: %s\n' % token)

    b.auth = None
    b.headers.update({'X-F5-Auth-Token': token})

    response = pre_checks(b, url_pool)
