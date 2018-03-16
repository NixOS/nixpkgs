mytmp="${TMPDIR:-/tmp}/temporary-bus-$(id -u)/"
mkdir -p "$mytmp"
dbusdir="$(mktemp -d -p "$mytmp")"
echo "$dbusdir" >&2
cat "@dbus@/share/dbus-1/system.conf" |
        grep -v '[<]user[>]messagebus' > "$dbusdir/system.conf"
"@dbus@"/bin/dbus-daemon --nopidfile --nofork \
        --config-file "@dbus@"/share/dbus-1/session.conf \
        --address "unix:path=$dbusdir/session"  >&2 &
"@dbus@"/bin/dbus-daemon --nopidfile --nofork \
        --config-file "$dbusdir/system.conf" \
        --address "unix:path=$dbusdir/system" >&2 &
export DBUS_SESSION_BUS_ADDRESS="unix:path=$dbusdir/session"
export DBUS_SYSTEM_BUS_ADDRESS="unix:path=$dbusdir/system"
