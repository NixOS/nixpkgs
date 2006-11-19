{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "upstart-0.3.0";
  src = fetchurl {
    url = http://upstart.ubuntu.com/download/upstart-0.3.0.tar.bz2;
    md5 = "269046f41c6418225306280044a799eb";
  };
  configureFlags = "--enable-compat";
  patches = [./cfgdir.patch];
}
