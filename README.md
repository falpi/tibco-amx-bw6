# TIBCO ActiveMatrix™ BusinessWorks 6.8 Docker

Image for running a complete single-node cluster instance of TIBCO ActiveMatrix™ BusinessWorks 6.8.0. The image do not contain TIBCO binaries itself and will install them on first run from external directory.

``This image for development use only``

# Usage
Download binaries installation files from [TIBCO site](https://edelivery.tibco.com/) and put them to **install_folder**.
Run container and it will install all products and configure single-node cluster :

```sh
docker run -d \
       --name tibco-bw-6.8 \
       --hostname tibco \
       --tmpfs /tmp:exec \
       -p 8079:8079 \
       -p 8777:8777 \
       -p 2222:2222 \
       -p 10022:22 \
       -p 13306:3306 \
      -v <install_folder>:/install \
       tibco-amx-bw:6.8.0
```
Then you can commit this container to have installed and configured product:
```sh
docker commit tibco-bw-6.8 tibco-amx-bw:6.8.0-installed
```
Software is installed in **/opt/tibco** folder
