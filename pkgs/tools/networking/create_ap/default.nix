{ stdenv, pkgs, fetchFromGitHub, iw, procps, hostapd, iproute, getopt, bash
, dnsmasq, iptables, coreutils, gnugrep, gnused, gawk, which, flock

, haveged ? null
, networkmanager ? null
# for iwconfig
, wirelesstools ? null

# To fall back to haveged if entropy is low.
#
# Defaulting to false because not having it does not break things.
# If it is really needed, warnings will be logged to journal.
, useHaveged ? false

# nmcli is not required for create_ap.
# (defaulting to true because it is very likely already present)
, useNetworkManager ? true

# You only need this if 'iw' can not recognize your adapter.
, useWirelessTools ? true }:

assert useHaveged        -> !isNull haveged;
assert useNetworkManager -> !isNull networkmanager;
assert useWirelessTools  -> !isNull wirelesstools;

with stdenv.lib;
with stdenv.lib.lists;

let binPath = makeBinPath ([ iw procps hostapd iproute getopt bash dnsmasq
  iptables coreutils which flock gnugrep gnused gawk ]
  ++ optional useHaveged        haveged
  ++ optional useNetworkManager networkmanager
  ++ optional useWirelessTools  wirelesstools);
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "0.4.6";
  pname = "create_ap";

  src = fetchFromGitHub {
    owner = "oblique";
    repo = "create_ap";
    rev = "v${version}";
    sha256 = "0wwwdc63vg987512nac46h91lg0a1gzigdqrgijk4b4andr94cp4";
  };

  nativeBuildInputs = [ pkgs.makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin/
    mv create_ap $out/bin/create_ap
    wrapProgram $out/bin/create_ap --prefix PATH : ${binPath}
  '';

  meta = {
    homepage = https://github.com/oblique/create_ap;
    description = "Creates a NATed or Bridged WiFi Access Point";
    longDescription = ''
    Features:

    - Create an AP (Access Point) at any channel.
    - Choose one of the following encryptions: WPA, WPA2, WPA/WPA2, Open (no encryption).
    - Hide your SSID.
    - Disable communication between clients (client isolation).
    - IEEE 802.11n & 802.11ac support
    - Internet sharing methods: NATed or Bridged or None (no Internet sharing).
    - Choose the AP Gateway IP (only for 'NATed' and 'None' Internet sharing methods).
    - You can create an AP with the same interface you are getting your Internet connection.
    - You can pass your SSID and password through pipe or through arguments (see examples).

    See <link xlink:href="https://github.com/oblique/create_ap"/> for details.
    '';
    license = licenses.bsd2;
    maintainers = with maintainers; [ klntsky ];
    platforms = platforms.linux;
  };
}
