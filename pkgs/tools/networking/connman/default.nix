{ lib, pkgs }:

lib.makeScope pkgs.newScope (self: with self; {

  # All the defaults
  connman = callPackage ./connman { };

  connmanFull = connman.override {
    # TODO: Why is this in `connmanFull` and not the default build? See TODO in
    # nixos/modules/services/networking/connman.nix (near the assertions)
    enableNetworkManager = true;
    enableHh2serialGps = true;
    enableL2tp = true;
    enableIospm = true;
    enableTist = true;
  };

  connmanMinimal = connman.override {
    enableOpenconnect = false;
    enableOpenvpn = false;
    enableVpnc = false;
    vpnc = false;
    enablePolkit = false;
    enablePptp = false;
    enableLoopback = false;
    # enableEthernet = false; # If disabled no ethernet connection can be performed
    enableWireguard = false;
    enableGadget = false;
    # enableWifi = false; # If disabled no WiFi connection can be performed
    enableBluetooth = false;
    enableOfono = false;
    enableDundee = false;
    enablePacrunner = false;
    enableNeard = false;
    enableWispr = false;
    enableTools = false;
    enableStats = false;
    enableClient = false;
    # enableDatafiles = false; # If disabled, configuration and data files are not installed
  };

  connman_dmenu = callPackage ./connman_dmenu { };

  connman-gtk = callPackage ./connman-gtk { };

  connman-ncurses = callPackage ./connman-ncurses { };

  connman-notify = callPackage ./connman-notify { };
})
