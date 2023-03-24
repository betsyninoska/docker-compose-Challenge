import requests

url = 'http://service-flask-app:8000'

res = requests.get(url)


if res:

    print('Response OK')
    print(res)	
else:
    print('Fallo la solicitud')
    print(res.status_code)

