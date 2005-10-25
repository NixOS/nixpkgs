{stdenv, fetchurl, cracklib}:

stdenv.mkDerivation {
  name = "pam-0.80";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.nl.kernel.org/pub/linux/libs/pam/pre/library/Linux-PAM-0.80.tar.bz2;
    md5 = "ccff87fe639efdfc22b1ba4a0f08ec57";
  };
  patches = [./pam-pwd.patch ./pam-cracklib.patch ./pam-modules.patch];
  inherit cracklib;
}
