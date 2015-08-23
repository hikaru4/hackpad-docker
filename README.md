# Hackpad docker image

This container builds a container with the latest master build of Hackpad.

( https://github.com/dropbox/hackpad )

## build

`docker build -t hackpad-docker .`

## run

`docker run -p 9000:9000 --name hackpad-docker -d hackpad-docker`

