{ stdenv, fetchurl, perl, php, gdSupport ? false
, gd ? null, libpng ? null, zlib ? null
}:

stdenv.mkDerivation {
  name = "nagios-4.0.7";

  src = fetchurl {
    url = mirror://sourceforge/nagios/nagios-4.x/nagios-4.0.7/nagios-4.0.7.tar.gz;
    sha256 = "1687qnbsag84r57y9745g2klypacfixd6gkzaj42lmzn0v8y27gg";
  };

  patches = [./nagios.patch];
  buildInputs = [php perl] ++ (if gdSupport then [gd libpng zlib] else []);
  buildFlags = "all";
  installTargets = "install install-config";

  meta = {
    description = "A host, service and network monitoring program";
    homepage = http://www.nagios.org/;
    license = "GPL";
  };
}
