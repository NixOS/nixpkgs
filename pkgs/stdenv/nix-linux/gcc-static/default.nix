{stdenv, fetchurl}:
 
stdenv.mkDerivation {
  name = "gcc-static-3.3.4";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://losser.st-lab.cs.uu.nl/~armijn/.nix/gcc-3.3.4-static-nix.tar.gz;
    md5 = "8b5c3a5881209edb15682e5e0c7459e4";
  };
}
