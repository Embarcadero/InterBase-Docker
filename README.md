# InterBase in Docker <img src="https://user-images.githubusercontent.com/821930/228645057-cc7e2bad-eac7-4c12-8250-089aa4cf77f1.png" align="right">

Dockerfile build for building [Embarcadero InterBase](https://interbase.com/) containers. The current version installs InterBase 2020 Update 4. You need an InterBase server license to use this.

1. Copy `Dockerfile`, `values.txt`, and `ibstart.sh` into a directory.
2. Run `docker build -t ib2020u4 .` where ib2020u4 is the tag name. If you update it, then change it below as well.
3. First time run:
```
docker run -it -p 3050:3050 --name interbase --mount source=iblicense,target=/opt/interbase/license --mount source=interbase,target=/opt/interbase docker.io/library/ib2020u4
```
This will run the license manager, storing the license in `/opt/interbase/license`. This keeps the license static, while the InterBase binaries are ephemeral so subsequent containers can contain updates.

4. Since we have the container a name, we need to remove it before running it again: `docker container rm interbase`

5. If successfully registered, run the container in the background
```
docker run -d -p 3050:3050 --name interbase --mount source=iblicense,target=/opt/interbase/license --mount source=interbase,target=/opt/interbase docker.io/library/ib2020u4
```

6. When you create a database, store in the path `/opt/interbase` which is mapped to the external _interbase_ volume. This keeps the database files persistent. 

7. In the future you can stop the InterBase container with `docker container stop interbase` and restart it with `docker container start interbase`. You only need to remove it if you are changing the _run_ command that was used to launch it.

---

_This software is Copyright &copy; 2023 by [Embarcadero Technologies, Inc.](https://www.embarcadero.com/)_

_You may only use this software if you are an authorized licensee of Embarcadero [InterBase](https://interbase.com/). See the latest [software license agreement](https://www.embarcadero.com/products/interbase/interbase-eula) for updates or changes._

![Embarcadero(Black-100px)](https://user-images.githubusercontent.com/821930/211648635-c0db6930-120c-4456-a7ea-dc7612f01451.png#gh-light-mode-only)
![Embarcadero(White-100px)](https://user-images.githubusercontent.com/821930/211649057-7f1f1f07-a79f-44d4-8fc1-87c819386ec6.png#gh-dark-mode-only)
