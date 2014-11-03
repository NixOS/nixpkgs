{ stdenv, fetchurl, libpcap, sqlite }:

stdenv.mkDerivation rec {
  name = "reaver-wps-1.4";

  src = fetchurl {
    url = http://reaver-wps.googlecode.com/files/reaver-1.4.tar.gz;
    sha256 = "0bdjai4p8xbsw8zdkkk43rgsif79x0nyx4djpyv0mzh59850blxd";
  };

  buildInputs = [ libpcap sqlite ];

  prePatch = ''
    cd src
  '';

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = {
    description = "Brute force attack against Wifi Protected Setup";
    homepage = http://code.google.com/p/reaver-wps;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
