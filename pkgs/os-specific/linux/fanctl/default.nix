{ stdenv, lib, fetchurl, gnugrep, glibc, gawk, coreutils, bridge-utils, iproute
, dnsmasq, iptables, kmod, utillinux, gnused }:

stdenv.mkDerivation rec {
  name = "fanctl-${version}";

  version = "0.12.0";

  src = fetchurl {
    url = "https://launchpad.net/ubuntu/+archive/primary/+files/ubuntu-fan_${version}.tar.xz";
    sha256 = "0lj7371n06sg5mlbbfgvm0qhzgp464n6v55rgs7kmmx4d37gb5fl";
  };

  # The Ubuntu package creates a number of state/config directories upon
  # installation, and so the fanctl script expects those directories to exist
  # before being used. Instead, we patch the fanctl script to gracefully handle
  # the fact that the directories might not exist yet.
  # Also, when dnsmasq is given --conf-file="", it will still attempt to read
  # /etc/dnsmasq.conf; if that file does not exist, dnsmasq subsequently fails,
  # so we'll use /dev/null, which actually works as intended.
  patches = [ ./robustness.patch ];

  postPatch = ''
    substituteInPlace fanctl \
      --replace '@PATH@' \
                '${lib.makeBinPath [
                     gnugrep gawk coreutils bridge-utils iproute dnsmasq
                     iptables kmod utillinux gnused
                     glibc # needed for getent
                   ]}'
  '';

  installPhase = ''
    mkdir -p $out/bin $out/man/man8
    cp fanctl.8 $out/man/man8
    cp fanctl $out/bin
  '';

  meta = with lib; {
    description = "Ubuntu FAN network support enablement";
    homepage = https://launchpad.net/ubuntu/+source/ubuntu-fan;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
