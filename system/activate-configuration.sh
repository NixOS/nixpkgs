#! @shell@

systemConfig="$1"
if test -z "$systemConfig"; then
    systemConfig="/system" # for the installation CD
fi

export PATH=/empty
for i in @path@; do PATH=$PATH:$i/bin:$i/sbin; done


# Needed by some programs.
ln -sfn /proc/self/fd /dev/fd
ln -sfn /proc/self/fd/0 /dev/stdin
ln -sfn /proc/self/fd/1 /dev/stdout
ln -sfn /proc/self/fd/2 /dev/stderr


# Set up the statically computed bits of /etc.
staticEtc=/etc/static
rm -f $staticEtc
ln -s @etc@/etc $staticEtc
for i in $(cd $staticEtc && find * -type l); do
    mkdir -p /etc/$(dirname $i)
    rm -f /etc/$i
    if test -e "$staticEtc/$i.mode"; then
        # Create a regular file in /etc.
        cp $staticEtc/$i /etc/$i
        chown 0.0 /etc/$i
        chmod "$(cat "$staticEtc/$i.mode")" /etc/$i
    else
        # Create a symlink in /etc.
        ln -s $staticEtc/$i /etc/$i
    fi
done


# Remove dangling symlinks that point to /etc/static.  These are
# configuration files that existed in a previous configuration but not
# in the current one.  For efficiency, don't look under /etc/nixos
# (where all the NixOS sources live).
for i in $(find /etc/ \( -path /etc/nixos -prune \) -o -type l); do
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


# Various log/runtime directories.
mkdir -m 0755 -p /var/run
mkdir -m 0755 -p /var/run/console # for pam_console

touch /var/run/utmp # must exist
chmod 644 /var/run/utmp

mkdir -m 0755 -p /var/run/nix/current-load # for distributed builds
mkdir -m 0700 -p /var/run/nix/remote-stores

mkdir -m 0755 -p /var/log

touch /var/log/wtmp # must exist
chmod 644 /var/log/wtmp

touch /var/log/lastlog
chmod 644 /var/log/lastlog

mkdir -m 1777 -p /var/tmp


# Empty, read-only home directory of many system accounts.
mkdir -m 0555 -p /var/empty


# If there is no password file yet, create a root account with an
# empty password.
if ! test -e /etc/passwd; then
    rootHome=/root
    touch /etc/passwd; chmod 0644 /etc/passwd
    touch /etc/group; chmod 0644 /etc/group
    touch /etc/shadow; chmod 0600 /etc/shadow
    # Can't use useradd, since it complains that it doesn't know us
    # (bootstrap problem!). 
    echo "root:x:0:0:System administrator:$rootHome:@defaultShell@" >> /etc/passwd
    echo "root::::::::" >> /etc/shadow
    echo | passwd --stdin root
fi


# Create system users and groups.
@shell@ @createUsersGroups@ @usersList@ @groupsList@


# Set up Nix.
mkdir -p /nix/etc/nix
ln -sfn /etc/nix.conf /nix/etc/nix/nix.conf
chown root.nixbld /nix/store
chmod 1775 /nix/store


# Nix initialisation.
mkdir -m 0755 -p \
    /nix/var/nix/gcroots \
    /nix/var/nix/temproots \
    /nix/var/nix/manifests \
    /nix/var/nix/userpool \
    /nix/var/nix/profiles \
    /nix/var/nix/db \
    /nix/var/log/nix/drvs \
    /nix/var/nix/channel-cache
mkdir -m 1777 -p /nix/var/nix/gcroots/per-user
mkdir -m 1777 -p /nix/var/nix/profiles/per-user

ln -sf /nix/var/nix/profiles /nix/var/nix/gcroots/
ln -sf /nix/var/nix/manifests /nix/var/nix/gcroots/


# Make a few setuid programs work.
PATH=@systemPath@/bin:@systemPath@/sbin:$PATH
save_PATH="$PATH"

# Add the default profile to the search path for setuid executables.
PATH="/nix/var/nix/profiles/default/sbin:$PATH"
PATH="/nix/var/nix/profiles/default/bin:$PATH"

wrapperDir=@wrapperDir@
if test -d $wrapperDir; then rm -f $wrapperDir/*; fi
mkdir -p $wrapperDir
for i in @setuidPrograms@; do
    program=$(type -tp $i)
    if test -z "$program"; then
	# XXX: It would be preferable to detect this problem before
	# `activate-configuration' is invoked.
	echo "WARNING: No executable named \`$i' was found" >&2
	echo "WARNING: but \`$i' was specified as a setuid program." >&2
    else
        cp "$(type -tp setuid-wrapper)" $wrapperDir/$i
        echo -n "$program" > $wrapperDir/$i.real
        chown root.root $wrapperDir/$i
        chmod 4755 $wrapperDir/$i
    fi
done

@adjustSetuidOwner@ 

PATH="$save_PATH"

# Set the host name.  Don't clear it if it's not configured in the
# NixOS configuration, since it may have been set by dhclient in the
# meantime.
if test -n "@hostName@"; then
    hostname @hostName@
else
    # dhclient won't do anything if the hostname isn't empty.
    if test "$(hostname)" = "(none)"; then
	hostname ''
    fi
fi


# Make this configuration the current configuration.
# The readlink is there to ensure that when $systemConfig = /system
# (which is a symlink to the store), /var/run/current-system is still
# used as a garbage collection root.
ln -sfn "$(readlink -f "$systemConfig")" /var/run/current-system


# Prevent the current configuration from being garbage-collected.
ln -sfn /var/run/current-system /nix/var/nix/gcroots/current-system
