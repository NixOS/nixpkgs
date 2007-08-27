{stdenv, fetchurl, cracklib, flex}:

stdenv.mkDerivation {
  name = "linux-pam-0.99.6.3";
  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://kernel/linux/libs/pam/pre/library/Linux-PAM-0.99.6.3.tar.bz2;
    md5 = "4c2830ed55a41e795af6a482009a036c";
  };
  buildInputs = [flex];
  preConfigure = "configureFlags=\"--includedir=$out/include/security\"";
}
