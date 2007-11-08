{ stdenv, fetchurl, perl }:

stdenv.mkDerivation {
  name = "nagios-2.10";

  src = fetchurl {
    url = mirror://sourceforge/nagios/nagios-2.10.tar.gz;
    md5 = "8c3a29e138f2ff8c8abbd3dd8a40c4b6";
  };

  patches = [./nagios.patch];
  buildInputs = [perl];
  buildFlags = "all";
  installTargets = "install install-config";

  meta = {
    description = "A host, service and network monitoring program";
    homepage = http://www.nagios.org/;
    license = "GPL";
  };
}
