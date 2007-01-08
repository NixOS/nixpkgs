{ stdenv, fetchurl, perl }:

stdenv.mkDerivation {
  name = "nagios-2.6";

  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/nagios/nagios-2.6.tar.gz;
    md5 = "a032edba07bf389b803ce817e9406c02";
  };

  patches = [./nagios.patch];
  buildInputs = [perl];
  buildFlags = "all";
  installTargets = "install install-config";
}
