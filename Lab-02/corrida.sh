#!/bin/bash

echo "INICIO Bash "

mkdir src
cd src
mkdir app


touch app/corrida2.sh

echo -e "#!/bin/bash
docker build -t app-python:1.0.0 . 
docker network create flask
docker run -d --name service-flask-app --network flask -p 8000:8000 app-python:1.0.0"> app/corrida2.sh



touch app/app.py
echo -e  "import sqlite3
from flask import Flask, render_template


def get_db_connection():
    conn = sqlite3.connect('database.db')
    conn.row_factory = sqlite3.Row
    return conn



app = Flask(__name__)

@app.route('/')




def index():
    conn = get_db_connection()
    posts = conn.execute('SELECT * FROM posts').fetchall()
    conn.close()
    return render_template('index.html', posts=posts)
    
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
" > app/app.py




echo "Creando Dockerfile"

touch app/Dockerfile


echo -e 'FROM python:3.9.2
WORKDIR /app
COPY requirements.txt /app
RUN pip install -r requirements.txt
COPY . .
EXPOSE 8000
CMD ["python3", "./app.py"]
' >app/Dockerfile




echo "Creando Init_db"

touch app/init_db.py

echo -e "import sqlite3

connection = sqlite3.connect('database.db')


with open('schema.sql') as f:
    connection.executescript(f.read())

cur = connection.cursor()

cur.execute('INSERT INTO posts (title, content) VALUES (?, ?)',
            ('Primer Desafio', 'imagen con un servidor web Apache y el mismo contenido que en la carpeta content')
            )

cur.execute('INSERT INTO posts (title, content) VALUES (?, ?)',
            ('Segundo Desafio', 'crea una API basica de flask')
            )

cur.execute('INSERT INTO posts (title, content) VALUES (?, ?)',
            ('Tercer desafio', 'Poke Python')
            )

cur.execute('INSERT INTO posts (title, content) VALUES (?, ?)',
            ('Cuarto  desafio', 'Deploy to Registry DockerHub')
            )


connection.commit()
connection.close()" > app/init_db.py

echo "Creando app/requeriments.txt"

touch app/requirements.txt

echo -e "Flask==2.2.3
werkzeug== 2.2.3" > app/requirements.txt

touch app/schema.sql
echo -e "DROP TABLE IF EXISTS posts;

CREATE TABLE posts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    title TEXT NOT NULL,
    content TEXT NOT NULL
);" > app/schema.sql



echo "Creando static y sus archivos"
mkdir app/static
mkdir app/static/css	
touch app/static/style.css

echo -e "border: 2px #eee solid;
    color: brown;
    text-align: center;
    padding: 10px;
}" > app/static/style.css

mkdir app/templates
touch app/templates/base.html

echo -e "<!doctype html>
<html lang='en'>
  <head>
    <!-- Required meta tags -->
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>

    <!-- Bootstrap CSS -->
    <link rel='stylesheet' href='https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css' integrity='sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T' crossorigin='anonymous'>

    <title>{% block title %} {% endblock %}</title>
  </head>
  <body>
    <nav class='navbar navbar-expand-md navbar-light bg-light'>
        <a class='navbar-brand' href='{{ url_for('index')}}'>Bootcamp Devops</a>
        <button class='navbar-toggler' type='button' data-toggle='collapse' data-target='#navbarNav' aria-controls'navbarNav' aria-expanded='false' aria-label='Toggle navigation'>
            <span class='navbar-toggler-icon'></span>
        </button>
        <div class='collapse navbar-collapse' id='navbarNav'>
            <ul class='navbar-nav'>
            <li class='nav-item active'>
                <a class='nav-link' href='#'>Docker</a>
            </li>
            </ul>
        </div>
    </nav>
    <div class='container'>
        {% block content %} {% endblock %}
    </div>

    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src='https://code.jquery.com/jquery-3.3.1.slim.min.js' integrity='sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo' crossorigin='anonymous'></script>
    <script src='https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js' integrity='ha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1' crossorigin='anonymous'></script>
    <script src='https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js' integrity='sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM' crossorigin='anonymous'></script>
  </body>
</html>
" > app/templates/base.html

touch >app/templates/index.html

echo -e "{% extends 'base.html' %}

{% block content %}
    <h1>{% block title %} Challenge 4 Docker {% endblock %}</h1>
    {% for post in posts %}
        <a href="#">
            <h2>{{ post['title'] }}</h2>
            <b>{{ post['content'] }}</b>

        </a>
        <span class="badge badge-primary">{{ post['created'] }}</span>
        <hr>
    {% endfor %}
{% endblock %}" > app/templates/index.html



echo "********************************consumer********************************"

mkdir consumer



touch consumer/corrida3.sh

echo -e "#!/bin/bash

#docker rm consumer-python
docker build -t consumer-python:1.0.0 .
docker images
docker run -it -e LOCAL=true --network flask consumer-python:1.0.0
docker ps -a
" > consumer/corrida3.sh

touch consumer/consumer.py
echo -e "import requests

url = 'http://service-flask-app:8000'

res = requests.get(url)


if res:

    print('Response OK')
    print(res)	
else:
    print('Fallo la solicitud')
    print(res.status_code)
" > consumer/consumer.py


touch consumer/Dockerfile
echo -e "FROM python:3.9.2
WORKDIR /app
COPY requirements.txt /app
RUN pip install -r requirements.txt
COPY . .
CMD ["python3", "./consumer.py"]
" > consumer/Dockerfile


touch consumer/requirements.txt
echo -e "requests" > consumer/requirements.txt


touch docker-compose.yml
echo -e "version: '3.7'
services:
  app:
    build: ./app
    ports:
      - '8000:8000'
    networks:
      - flask
  consumer:
    build: ./consumer
    depends_on:
      - app
    networks:
      - flask
networks:
  flask:
    driver: bridge
" > docker-compose.yml


echo "Ejecutando la base de datos"

#python3 init_db.py




cd ..

chmod -R 777 src
chown -R www-data:www-data src

apt install tree
tree