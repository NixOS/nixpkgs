{ callPackage }:

{
  # All the defaults
  connman = callPackage ./connman.nix { };

  connmanFull = callPackage ./connman.nix {
    # TODO: Why is this in `connmanFull` and not the default build? See TODO in
    # nixos/modules/services/networking/connman.nix (near the assertions)
    enableNetworkManager = true;
    enableHh2serialGps = true;
    enableL2tp = true;
    enableIospm = true;
    enableTist = true;
  };

  connmanMinimal = callPackage ./connman.nix {
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
}
