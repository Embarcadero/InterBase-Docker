# InterBase-Docker
Dockerfile build for building [Embarcadero InterBase](https://interbase.com/) containers. You need an InterBase server license to use this.

1. Copy `Dockerfile`, `values.txt`, and `ibstart.sh` into a directory.
2. Run `docker build -t ib2020u4 .` where ib2020u4 is the tag name. If you update it, then change it below as well.
3. First time run:
```
docker run -it -p 3050:3050 --name interbase --mount source=iblicense,target=/opt/interbase/license  docker.io/library/ib2020u4
```
This will run the license manager. Setting the target to `/opt/interbase/license` should keep the InterBase binaries ephemeral so that subsequent containers can contain updates.

4. If successfully registered, run the container in the background
```
docker run -d -p 3050:3050 --name interbase --mount source=iblicense,target=/opt/interbase/license  docker.io/library/ib2020u4
```

_This software is Copyright &copy; 2023 by [Embarcadero Technologies, Inc.](https://www.embarcadero.com/)_

_You may only use this software if you are an authorized licensee of an Embarcadero developer tools product. This software is considered a Redistributable as defined in the software license agreement that comes with the Embarcadero Products and is governed by the terms of such [software license agreement](https://www.embarcadero.com/products/rad-studio/rad-studio-eula)._

![Embarcadero(Black-100px)](https://user-images.githubusercontent.com/821930/211648635-c0db6930-120c-4456-a7ea-dc7612f01451.png#gh-light-mode-only)
![Embarcadero(White-100px)](https://user-images.githubusercontent.com/821930/211649057-7f1f1f07-a79f-44d4-8fc1-87c819386ec6.png#gh-dark-mode-only)
