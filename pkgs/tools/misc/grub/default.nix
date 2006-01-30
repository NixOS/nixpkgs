{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "grub-0.97";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/grub-0.97.tar.gz;
    md5 = "cd3f3eb54446be6003156158d51f4884";
  };
}
