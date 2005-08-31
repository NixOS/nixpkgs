#! @bash@/bin/sh -e

export PATH=@bash@/bin:@coreutilsdiet@/bin:@coreutils@/bin:@findutils@/bin:@utillinux@/bin:@utillinux@/sbin:@e2fsprogs@/sbin:@grub@/sbin:@sysvinitPath@/sbin:@gnugrep@/bin:@which@/bin:@gnutar@/bin

tty=$1

exec < $tty > $tty 2>&1

echo
echo "=== Welcome to Nix! ==="

export HOME=/
cd $HOME

exec @bash@/bin/sh
