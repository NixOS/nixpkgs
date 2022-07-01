{ stdenv, lib, fetchFromGitHub, makeWrapper

# --- Runtime Dependencies ---
, bash, procps, iproute2, dnsmasq, iptables
, coreutils, flock, gawk, getopt, gnugrep, gnused, which
# `nmcli` is not required for create_ap.
# Use NetworkManager by default because it is very likely already present
, useNetworkManager ? true
, networkmanager

# --- WiFi Hotspot Dependencies ---
, useWifiDependencies ? true
, hostapd, iw
# You only need this if 'iw' can not recognize your adapter.
, useWirelessTools ? true
, wirelesstools # for iwconfig
# To fall back to haveged if entropy is low.
# Defaulting to false because not having it does not break things.
# If it is really needed, warnings will be logged to journal.
, useHaveged ? false
, haveged
# You only need this if you wish to show WiFi QR codes in terminal
, useQrencode ? true
, qrencode
}:

stdenv.mkDerivation rec {
  pname = "linux-router";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "garywill";
    repo = "linux-router";
    rev = "${version}";
    sha256 = "sha256-QBxlqKNaCUMVkm8rVTZ5z6tTN9WxgDQxeNkbgCe9KEg=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = with lib; let
      binPath = makeBinPath ([ procps iproute2 getopt bash dnsmasq
        iptables coreutils which flock gnugrep gnused gawk ]
        ++ optional useNetworkManager                          networkmanager
        ++ optional useWifiDependencies                        hostapd
        ++ optional useWifiDependencies                        iw
        ++ optional (useWifiDependencies && useWirelessTools)  wirelesstools
        ++ optional (useWifiDependencies && useHaveged)        haveged
        ++ optional (useWifiDependencies && useQrencode)       qrencode);
    in
    ''
      mkdir -p $out/bin/ $out/.bin-wrapped
      mv lnxrouter $out/.bin-wrapped/lnxrouter
      makeWrapper $out/.bin-wrapped/lnxrouter $out/bin/lnxrouter --prefix PATH : ${binPath}
    '';

  meta = with lib; {
    homepage = "https://github.com/garywill/linux-router";
    description = "Set Linux as router / Wifi hotspot / proxy in one command";
    longDescription = ''
      Features:

      - Create a NATed sub-network
      - Provide Internet
      - DHCP server and RA
      - DNS server
      - IPv6 (behind NATed LAN, like IPv4)
      - Creating Wifi hotspot:
        - Channel selecting
        - Choose encryptions: WPA2/WPA, WPA2, WPA, No encryption
        - Create AP on the same interface you are getting Internet (require same channel)
      - Transparent proxy (redsocks)
      - DNS proxy
      - Compatible with NetworkManager (automatically set interface as unmanaged)
    '';
    license = licenses.lgpl21;
    maintainers = with maintainers; [ x3ro ];
    platforms = platforms.linux;
  };
}
