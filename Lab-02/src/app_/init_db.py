import sqlite3

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
connection.close()
