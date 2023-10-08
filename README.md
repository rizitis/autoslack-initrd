# autoslack-initrd
```
script which running during shutdown or reboot and mkinitrd for generic kernel if slackpkg upgrade-all upgraded kernel
```
## INSTALL
```
cd /etc/rc.d/  && wget https://raw.githubusercontent.com/rizitis/autoslack-initrd/main/autoslack-initrd.sh
chmod +x autoslack-initrd.sh
```
```
nano /etc/rc.d/rc.local_shutdown
```
and paste this
```
# autoslack-initrd
if [ -x /etc/rc.d/autoslack-initrd.sh ]; then
   /etc/rc.d/autoslack-initrd.sh
fi
```
The best position to place it 
is before
```
# slackup-grub
if [ -x /etc/rc.d/slackup-grub.sh ]; then
   /etc/rc.d/slackup-grub.sh
fi
```
If you dont have slackup-grub installed 

https://github.com/rizitis/slackup-grub

### Note that 
if you dont have slackup-grub installed then you should find a way to auto-update your bootloader.
else...this script will not help.

#### HOW TO
Very first time , after installation , you must run script manually to create a database.
You can do it as root
```
/etc/rc.d/autoslack-initrd.sh
```

And thats all, after that, if you forget to 
```
geninitrd
```
...for your generic kernel, it will do it for you. 

