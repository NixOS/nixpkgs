{stdenv, fetchurl, SDL}:

stdenv.mkDerivation { 
  name = "dosbox-0.65";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/dosbox-0.65.tar.gz;
    md5 = "fef84c292c3aeae747368b9875c1575a";
  };
  buildInputs = [SDL];
}
