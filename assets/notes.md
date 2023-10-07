## rsnyc
upload:     rsync -rlptzv --progress --delete --exclude=.git . djh@10.29.0.222:~/Code/CSAPP
download:   rsync -rlptzv --progress --delete --exclude=.git djh@10.29.0.222:~/Code/CSAPP/ .

## git
git config oh-my-zsh.hide-info 1

## man
man <command> | col -b > <file>

## docker
- **pull images**:
```
docker pull --platform linux/amd64 ubuntu:20.04
```
- **create containers**:
```
docker run -it --privileged -h Ubuntu-Docker -v /Users/djh/Ding/code/CSAPP:/CSAPP -w /CSAPP --name=CSAPP --platform=linux/amd64 ubuntu:20.04 /bin/bash

apt update && apt install vim build-essential gdb  gcc-multilib python3 neofetch ranger git man-db
```

- **attach container**:
```
docker start CSAPP && docker attach CSAPP
cd ./CSAPP/lab
```

- **container list**:
```
docker ps -a
```

- **tar**
```
tar -xvf datalab-handout.tar 
```

- **tar**
```
gcc -o hello hello.c && ./hello
gcc -o main main.c && ./main && rm main
```
