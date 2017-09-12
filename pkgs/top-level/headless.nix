# The goal for this package set is to run without cruft you wouldn't need on a headless server/VM.
# Typical things one might want to disable here are audio support, HID device support, graphical
# support, and so on. If that seems like a lot of concerns rolled into one, this is a trade-off:
# the more individual knobs we add, the more the combinatorics of building all these packages and
# maintaining all the various combinations, which is both a drain on Hydra and on maintainer time.
# This set seems like a reasonably common use case that was worth representing.
# See https://github.com/NixOS/nixpkgs/issues/29135 and https://github.com/NixOS/nixpkgs/issues/12877
# for more discussion on the pros and cons of these.

self: super: {
  dbus = super.dbus.override { x11Support = false; };
  networkmanager_fortisslvpn = super.networkmanager_fortisslvpn.override { withGnome = false; };
  networkmanager_l2tp = super.networkmanager_l2tp.override { withGnome = false; };
  networkmanager_openconnect = super.networkmanager_openconnect.override { withGnome = false; };
  networkmanager_openvpn = super.networkmanager_openvpn.override { withGnome = false; };
  networkmanager_pptp = super.networkmanager_pptp.override { withGnome = false; };
  networkmanager_vpnc = super.networkmanager_vpnc.override { withGnome = false; };
  networkmanager_iodine = super.networkmanager_iodine.override { withGnome = false; };
  pinentry = super.pinentry.override { gtk2 = null; qt4 = null; };
}
