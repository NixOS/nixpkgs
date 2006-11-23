#! @shell@

# !!! copied from stage 1; remove duplication


# Print a greeting.
echo
echo "<<< NixOS Stage 2 >>>"
echo


# Set the PATH.
export PATH=/empty
for i in @path@; do
    PATH=$PATH:$i/bin
    if test -e $i/sbin; then
        PATH=$PATH:$i/sbin
    fi
done


# Mount special file systems, initialise required directories.

rm -f /etc/mtab

if test -z "@readOnlyRoot@"; then
    #rootDev=$(grep "/dev/.* / " /proc/mounts | sed 's/^\([^ ]*\) .*/\1/')
    mount -o remount,rw /dontcare / # !!! check for failure
fi

needWritableDir() {
    if test -n "@readOnlyRoot@"; then
        mount -t tmpfs -o "mode=$2" none $1 $3
    else
        mkdir -m $2 -p $1
    fi
}

needWritableDir /etc 0755 -n # to shut up mount

test -e /etc/fstab || touch /etc/fstab # idem

mount -t proc none /proc
mount -t sysfs none /sys
mount -t tmpfs -o "mode=0755" none /dev
needWritableDir /tmp 01777
needWritableDir /var 0755
needWritableDir /nix/var 0755

mkdir -m 0755 -p /nix/var/nix/db
mkdir -m 0755 -p /nix/var/nix/gcroots
mkdir -m 0755 -p /nix/var/nix/temproots

mkdir -m 0755 -p /var/log

ln -sf /nix/var/nix/profiles /nix/var/nix/gcroots/


# Ensure that the module tools can find the kernel modules.
export MODULE_DIR=@kernel@/lib/modules/


# Start udev.
udevd --daemon


# Let udev create device nodes for all modules that have already been
# loaded into the kernel (or for which support is built into the
# kernel).
udevtrigger
udevsettle # wait for udev to finish


# Necessary configuration for syslogd.
mkdir -m 0755 -p /var/run
echo "*.* /dev/tty10" > /etc/syslog.conf
echo "syslog 514/udp" > /etc/services # required, even if we don't use it


# login/su absolutely need this.
test -e /etc/login.defs || touch /etc/login.defs 


# Enable a password-less root login.
if ! test -e /etc/passwd; then
    echo "root::0:0:root:/:@shell@" > /etc/passwd
fi
if ! test -e /etc/group; then
    echo "root:*:0" > /etc/group
fi


# Set up the Upstart jobs.
export UPSTART_CFG_DIR=/etc/event.d

ln -sf @upstartJobs@/etc/event.d /etc/event.d


# Show a nice greeting on each terminal.
cat > /etc/issue <<EOF

<<< Welcome to NixOS (\m) - Kernel \r (\l) >>>

You can log in as \`root'.


EOF


# Additional path for the interactive shell.
for i in @extraPath@; do
    PATH=$PATH:$i/bin
    if test -e $i/sbin; then
        PATH=$PATH:$i/sbin
    fi
done

cat > /etc/profile <<EOF
export PATH=$PATH
export MODULE_DIR=$MODULE_DIR
if test -f /etc/profile.local; then
    source /etc/profile.local
fi
EOF


# Set the host name.
hostname nixos


# Start an interactive shell.
#exec @shell@


# Start Upstart's init.
exec @upstart@/sbin/init -v
