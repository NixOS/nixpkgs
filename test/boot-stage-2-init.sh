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

# Mount special file systems.
mount -t tmpfs none /etc -n # to shut up mount
touch /etc/fstab # idem
mount -t proc none /proc
mount -t sysfs none /sys
mount -t tmpfs none /dev
mount -t tmpfs none /tmp
mount -t tmpfs none /var
mount -t tmpfs none /nix/var

mkdir -p /nix/var/nix/db
mkdir -p /nix/var/nix/gcroots
mkdir -p /nix/var/nix/temproots

# Create device nodes in /dev.
source @makeDevices@

# Ensure that the module tools can find the kernel modules.
export MODULE_DIR=@kernel@/lib/modules/

# Additional path for the interactive shell.
for i in @extraPath@; do
    PATH=$PATH:$i/bin
    if test -e $i/sbin; then
        PATH=$PATH:$i/sbin
    fi
done

# Start syslogd.
mkdir -p /var/run
#mkdir -p /var/log
#touch /var/log/messages
echo "*.* /dev/tty10" > /etc/syslog.conf
echo "syslog 514/udp" > /etc/services # required, even if we don't use it
@sysklogd@/sbin/syslogd &

# login/su absolutely need this.
touch /etc/login.defs 

# Enable a password-less root login.
echo "root::0:0:root:/:@shell@" > /etc/passwd
echo "root:*:0" > /etc/group

cat > /etc/profile <<EOF
export PATH=$PATH
export MODULE_DIR=$MODULE_DIR
EOF

# Set up inittab.
for i in $(seq 1 6); do 
    echo "$i:2345:respawn:@mingetty@/sbin/mingetty --noclear tty$i" >> /etc/inittab
done

# Show a nice greeting on each terminal.
cat > /etc/issue <<EOF

<<< Welcome to NixOS (\m) - Kernel \r (\l) >>>

You can log in as \`root'.


EOF

# Start an interactive shell.
#exec @shell@

# Start init.
exec init 2
