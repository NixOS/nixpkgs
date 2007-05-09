#! @shell@

systemConfig="$1"
if test -z "$systemConfig"; then
    systemConfig="/system" # for the installation CD
fi

export PATH=/empty
for i in @path@; do PATH=$PATH:$i/bin:$i/sbin; done


# Needed by some programs.
ln -sfn /proc/self/fd /dev/fd


# Set up the statically computed bits of /etc.
staticEtc=/etc/static
rm -f $staticEtc
ln -s @etc@/etc $staticEtc
for i in $(cd $staticEtc && find * -type l); do
    mkdir -p /etc/$(dirname $i)
    rm -f /etc/$i
    ln -s $staticEtc/$i /etc/$i
done


# Remove dangling symlinks that point to /etc/static.  These are
# configuration files that existed in a previous configuration but not
# in the current one.
for i in $(find /etc/ -type l); do
    target=$(readlink "$i")
    if test "${target:0:${#staticEtc}}" = "$staticEtc" -a ! -e "$i"; then
        rm -f "$i"
    fi
done


# Create the required /bin/sh symlink; otherwise lots of things
# (notably the system() function) won't work.
mkdir -m 0755 -p $mountPoint/bin
ln -sfn @bash@/bin/sh $mountPoint/bin/sh


# Allow the kernel to find our wrapped modprobe (which searches in the
# right location in the Nix store for kernel modules).  We need this
# when the kernel (or some module) auto-loads a module.
# !!! maybe this should only happen at boot time, since we shouldn't
# use modules that don't match the running kernel.
echo @modprobe@/sbin/modprobe > /proc/sys/kernel/modprobe


# Various log directories.
mkdir -m 0755 -p /var/run

touch /var/run/utmp # must exist
chmod 644 /var/run/utmp

mkdir -m 0755 -p /var/log

touch /var/log/wtmp # must exist
chmod 644 /var/log/wtmp

touch /var/log/lastlog
chmod 644 /var/log/lastlog


# If there is no password file yet, create a root account with an
# empty password.
if ! test -e /etc/passwd; then
    rootHome=/root
    touch /etc/passwd; chmod 0644 /etc/passwd
    touch /etc/group; chmod 0644 /etc/group
    touch /etc/shadow; chmod 0600 /etc/shadow
    # Can't use useradd, since it complain that it doesn't know us
    # (bootstrap problem!). 
    echo "root:x:0:0:System administrator:$rootHome:@defaultShell@" >> /etc/passwd
    echo "root::::::::" >> /etc/shadow
    groupadd -g 0 root
    echo | passwd --stdin root
fi


# Some more required accounts/groups.
if ! getent group nogroup > /dev/null; then
    groupadd -g 65534 nogroup
fi


# Set up Nix accounts.
if test -z "@readOnlyRoot@"; then

    if ! getent group nixbld > /dev/null; then
        groupadd -g 30000 nixbld
    fi

    for i in $(seq 1 10); do
        account=nixbld$i
        if ! getent passwd $account > /dev/null; then
            useradd -u $((i + 30000)) -g nogroup -G nixbld \
                -d /var/empty -s /noshell \
                -c "Nix build user $i" $account
        fi
    done

    mkdir -p /nix/etc/nix
    cat > /nix/etc/nix/nix.conf <<EOF
# WARNING: this file is generated.
build-users-group = nixbld
build-max-jobs = @maxJobs@
EOF

    chown root.nixbld /nix/store
    chmod 1775 /nix/store
fi


# Nix initialisation.
mkdir -m 0755 -p /nix/var/nix/db
mkdir -m 0755 -p /nix/var/nix/gcroots
mkdir -m 0755 -p /nix/var/nix/temproots
mkdir -m 0755 -p /nix/var/nix/profiles
mkdir -m 1777 -p /nix/var/nix/profiles/per-user

ln -sf /nix/var/nix/profiles /nix/var/nix/gcroots/


# Make a few setuid programs work.
PATH=@systemPath@/bin:@systemPath@/sbin:$PATH
wrapperDir=@wrapperDir@
if test -d $wrapperDir; then rm -f $wrapperDir/*; fi
mkdir -p $wrapperDir
for i in @setuidPrograms@; do
    program=$(type -tp $i)
    cp "$(type -tp setuid-wrapper)" $wrapperDir/$i
    echo -n $program > $wrapperDir/$i.real
    chown root.root $wrapperDir/$i
    chmod 4755 $wrapperDir/$i
done


# Set the host name.
hostname @hostName@


# Make this configuration the current configuration.
ln -sfn "$systemConfig" /var/run/current-system


# Prevent the current configuration from being garbage-collected.
ln -sfn /var/run/current-system /nix/var/nix/gcroots/current-system
