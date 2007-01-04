#! @shell@

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


# Various log directories.
mkdir -m 0755 -p /var/run

echo -n > /var/run/utmp # must exist
chmod 664 /var/run/utmp

mkdir -m 0755 -p /var/log


# If there is no password file yet, create a root account with an
# empty password.
if ! test -e /etc/passwd; then
    rootHome=/root
    touch /etc/passwd; chmod 0644 /etc/passwd
    touch /etc/group; chmod 0644 /etc/group
    touch /etc/shadow; chmod 0600 /etc/shadow
    # Can't use useradd, since it complain that it doesn't know us
    # (bootstrap problem!). 
    echo "root:x:0:0:System administrator:$rootHome:@shell@" >> /etc/passwd
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
build-users-group = nixbld
EOF

    chown root.nixbld /nix/store
    chmod 1775 /nix/store
fi


# Additional path for the interactive shell.
PATH=@wrapperDir@:@fullPath@/bin:@fullPath@/sbin

cat > /etc/profile <<EOF
export PATH=$PATH
export MODULE_DIR=@kernel@/lib/modules
export NIX_CONF_DIR=/nix/etc/nix
if test "\$USER" != root; then
    export NIX_REMOTE=daemon
fi

source $(dirname $(readlink -f $(type -tp nix-env)))/../etc/profile.d/nix.sh

alias ll="ls -l"

if test -f /etc/profile.local; then
    source /etc/profile.local
fi
EOF


# Nix initialisation.
mkdir -m 0755 -p /nix/var/nix/db
mkdir -m 0755 -p /nix/var/nix/gcroots
mkdir -m 0755 -p /nix/var/nix/temproots

ln -sf /nix/var/nix/profiles /nix/var/nix/gcroots/


# Make a few setuid programs work.
wrapperDir=@wrapperDir@
if test -d $wrapperDir; then rm -f $wrapperDir/*; fi
mkdir -p $wrapperDir
for i in passwd su; do
    program=$(type -tp $i)
    cp $(type -tp setuid-wrapper) $wrapperDir/$i
    echo -n $program > $wrapperDir/$i.real
    chown root.root $wrapperDir/$i
    chmod 4755 $wrapperDir/$i
done


# Set the host name.
hostname @hostName@
