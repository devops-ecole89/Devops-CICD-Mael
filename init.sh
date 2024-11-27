#supprimer les container et les images
sudo docker container rm -f container_flask
sudo docker image rm -f image_flask

#construire l'image
sudo docker build --no-cache -t image_flask .

#lancer le container
sudo docker run -d -p 5000:5000 --name container_flask image_flask

#tester l'application
sudo docker start container_flask

#logs de l'application
sudo docker logs container_flask

