{stdenv, fetchurl}:
  
stdenv.mkDerivation {
  name = "mktemp-1.5";
  
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/mktemp-1.5.tar.gz;
    md5 = "9a35c59502a228c6ce2be025fc6e3ff2";
  };
  
}
