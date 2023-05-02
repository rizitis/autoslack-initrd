#!/bin/bash

# Anagnostakis Ioannis GR Crete 26/03/2023
# Create initrd (generic kernel) when Slackware upgrade-all upgrade kernel release...
# 
# In my case I use SBKS and always have a backup kernel in my system. (https://github.com/rizitis/SBKS) #
# But just in case....

# Redistribution and use of this script, with or without modification, is
# permitted provided that the following conditions are met:
#
# 1. Redistributions of this script must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
#  THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR IMPLIED
#  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
#  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
#  EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
#  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
#  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
#  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
#  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
#  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



# root
if [ "$EUID" -ne 0 ];then
echo "ROOT ACCESS PLEASE OR GO HOME..."
exit 1
fi


dir=/usr/local/autoslack-initrd
file=/usr/local/autoslack-initrd/autoslack-initrd.TXT
file2=/usr/local/autoslack-initrd/autoslack-initrd.BAK
file3=/usr/local/autoslack-initrd/autoslack-initrd

# if first time run mk autoslack-initrd dir
if [ -d "$dir" ]
then
echo "autoslack-initrd is installed"
else
mkdir -p "$dir" || exit 
/bin/ls -tr /var/lib/pkgtools/packages | grep kernel | tail -2 > "$file"
echo "Looks like you are running autoslack-initrd for first time?"
exit
fi

cd "$dir" || exit
/bin/ls -tr /var/lib/pkgtools/packages | grep kernel | tail -2 > "$file3"

if [ -f /usr/local/autoslack-initrd/autoslack-initrd.TXT ]
then 
mv "$file" "$file2" || exit
else 
echo "************************************"
echo "Something went wrong, ATTENSION... *"
echo "************************************"
exit
fi

set -e

if [ -f "$file2" ]
then 
/bin/ls -tr /var/lib/pkgtools/packages | grep kernel | tail -2 > "$file"
fi

# we will remove the "-c" (clear) option from mkinitrd, else if second generic kernel exist...boom
filename="autoslack-initrd.sh"
Clear="mkinitrd -c"
NOClear="mkinitrd"
if cmp -s autoslack-initrd.TXT autoslack-initrd.BAK ; then
echo "autoslack-initrd message:"
echo "NO KERNEL UPDATE WAS FOUND"
sleep 2
else
echo "KERNEL WAS UPDATED, FIXING GENERIC KERNEL..."
sed -i '/kernel-source/d' /usr/local/autoslack-initrd/autoslack-initrd
wait
sed -i 's/kernel-modules-//g' /usr/local/autoslack-initrd/autoslack-initrd
wait
sed -i 's/-x/\n/g' /usr/local/autoslack-initrd/autoslack-initrd
wait
sed -i '$d' /usr/local/autoslack-initrd/autoslack-initrd
wait 
VERSION=$(cat $file3)
echo "$VERSION"
bash /usr/share/mkinitrd/mkinitrd_command_generator.sh -k "$VERSION" > /usr/local/autoslack-initrd/autoslack-initrd.sh
sleep 1
sed -i "s/$Clear/$NOClear/" /usr/local/autoslack-initrd/autoslack-initrd.sh
wait
bash /usr/local/autoslack-initrd/autoslack-initrd.sh
echo "autoslack-initrd finish its job"
echo "time for slackup-grub to do its job..."
echo ""
fi







