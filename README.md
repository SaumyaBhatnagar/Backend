# InvolveSoft - Backend Setup
The backend consists of the following components:
  - Ubuntu 16.04 LTS
  - Apache 2.4
  - PHP 7.0
  - MySQL 5.7
  - Zend Framework 2.4
  - Doctrine 2.5
  - Vagrant
  - GIT
  - Composer
  - And more!

# Setup

- Install Vagrant for your OS (Linux/Mac/Win)  
- Clone the repository:
 ```sh
 git clone https://github.com/SaumyaBhatnagar/Backend.git
 ```
  - cd to the cloned repository
  - Run: 
 ```sh
$ vagrant up
```
  - Wait for vagrant to complete installation
  - After installation completes to login into the box, run:
```sh
$ vagrant ssh
```
  - Your project and it's dependencies have been installed in:
```sh
$ cd /var/www/html/
```
  - And that's it! The backend has been configured to run on port 80 on the Vagrant box, and the port 8080 is forwarded on the host machine. To access the app, go to:

```sh
http://localhost:8080/public/index.php
```
 
### Note:

If you get this error:

```sh
Vagrant cannot forward the specified ports on this VM, since they
would collide with some other application that is already listening
on these ports. The forwarded port to 8080 is already in use
on the host machine.
```
Then you may already have this port used on the host machine by a running Apache instance, or another Vagrant box may be running with its 80 port forwarded. 

To view current Vagrant boxes:

```sh
$ vagrant global-status --prune
```
  
