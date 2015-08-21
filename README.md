# docker-images-openmedivault
A docker container for [openmediavault](http://www.openmediavault.org/)

## To run
clone my repo 

cd docker-images-openmedivault

docker build -t omv .

docker run -t -i -p 80:80 OMV

###Start services
service ssh start
service php5-fpm start
service nginx start
service openmediavault-engined start
service rrdcached start
service collectd start

Go to your browser  http://IP_OF_DOCKER

Add eth0 with dhcp in System->Network->Interfaces
