{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "par2cmdline-0.4";
  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/parchive/par2cmdline-0.4.tar.gz;
    md5 = "1551b63e57e3c232254dc62073b723a9";
  };
}
