python3 -m venv venv
source venv/bin/activate
pip install django
django-admin startproject config .
python manage.py startapp api
python manage.py runserver
python manage.py runserver localhost:8000

# connect localserver to internet
# sign in ngrok web site and get your toke
sudo apt update && sudo apt install ngrok
ngrok config add-authtoken "<token>"
ngrok http http://localhost:8000