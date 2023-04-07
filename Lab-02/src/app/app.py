from flask import Flask, render_template
from flask_mysqldb import MySQL

app = Flask(__name__)

app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = '123456'
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_DB'] = 'challenge'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'

mysql = MySQL(app)

# mysql.init_app(app)

@app.route('/')
def CONNECT_DB():
    CS = mysql.connection.cursor()
    # CS.execute('''CREATE TABLE TABLE_NAME (id INTEGER, name VARCHAR(20))''')
    # CS.execute('''INSERT INTO TABLE_NAME VALUES (1, 'Harry')''')
    # CS.execute('''INSERT INTO TABLE_NAME VALUES (2, 'Arthor')''')
    # mysql.connection.commit()
    # return 'Executed successfully'

    CS.execute("SELECT * FROM posts")
    Executed_DATA = CS.fetchall()


    #print(Executed_DATA)

    #return str(Executed_DATA[1]['title'])

    return render_template('index.html', posts=Executed_DATA)
    #return render_template('template/index.html')



#if __name__ == '__main__':
app.run(host='0.0.0.0', port=8000)



if __name__=='__main__':
    app.run(debug=True)
