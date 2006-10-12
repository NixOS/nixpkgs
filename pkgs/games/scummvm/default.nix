{stdenv, fetchurl, SDL}:

stdenv.mkDerivation {
  name = "scummvm-0.9.0";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/scummvm-0.9.0.tar.bz2;
    md5 = "5eede9c97d1883f80770a3e211419783";
  };
  buildInputs = [SDL];
}
