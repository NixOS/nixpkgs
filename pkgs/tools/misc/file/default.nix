{stdenv, fetchurl}:
 
stdenv.mkDerivation {
  name = "file-4.17";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/file-4.17.tar.gz;
    md5 = "50919c65e0181423d66bb25d7fe7b0fd";
  };
}
