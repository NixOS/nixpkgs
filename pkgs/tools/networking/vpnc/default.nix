{ stdenv, fetchurl, nettools, libgcrypt, perl, gawk, makeWrapper }:

stdenv.mkDerivation rec {
  name = "vpnc-0.5.3";
  src = fetchurl {
    url = "http://www.unix-ag.uni-kl.de/~massar/vpnc/${name}.tar.gz";
    sha256 = "1128860lis89g1s21hqxvap2nq426c9j4bvgghncc1zj0ays7kj6";
  };

  patches = [ ./makefile.patch ];

  # The `etc/vpnc/vpnc-script' script relies on `which' and on
  # `ifconfig' as found in net-tools (not GNU Inetutils).
  propagatedBuildInputs = [ nettools ];

  buildInputs = [libgcrypt perl makeWrapper];

  preConfigure = ''
    substituteInPlace "vpnc-script.in" \
      --replace "which" "type -P" \
      --replace "awk" "${gawk}/bin/awk"

    substituteInPlace "config.c" \
      --replace "/etc/vpnc/vpnc-script" "$out/etc/vpnc/vpnc-script"

    substituteInPlace "pcf2vpnc" \
      --replace "/usr/bin/perl" "${perl}/bin/perl"
  '';

  postInstall = ''
    for i in $out/{bin,sbin}/*
    do
      wrapProgram $i --prefix PATH :  \
        "${nettools}/bin:${nettools}/sbin"
    done
  '';

  meta = {
    description = ''VPNC, a virtual private network (VPN) client
                    for Cisco's VPN concentrators'';
    homepage = http://www.unix-ag.uni-kl.de/~massar/vpnc/;
    license = "GPLv2+";
  };
}
