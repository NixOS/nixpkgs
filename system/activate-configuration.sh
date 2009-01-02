#! @shell@

source @newActivationScript@


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
	#echo "WARNING: No executable named \`$i' was found" >&2
	#echo "WARNING: but \`$i' was specified as a setuid program." >&2
        true
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
