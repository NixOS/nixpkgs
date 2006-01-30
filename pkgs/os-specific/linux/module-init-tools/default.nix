{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "module-init-tools-3.2.2";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/module-init-tools-3.2.2.tar.bz2;
    md5 = "a1ad0a09d3231673f70d631f3f5040e9";
  };
}


