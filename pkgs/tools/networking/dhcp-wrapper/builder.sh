. $stdenv/setup
. $makeWrapper

makeWrapper "$dhcp/sbin/dhclient" "$out/sbin/dhclient" \
--set PATH_DHCLIENT_SCRIPT "$dhcp/sbin/dhclient-script"
