{stdenv, fetchurl}:

if stdenv.system == "x86_64-linux" then
  abort "Grub doesn't build on x86_64-linux.  You should use the build for i686-linux instead."
else

stdenv.mkDerivation {
  name = "grub-0.97";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/grub-0.97.tar.gz;
    md5 = "cd3f3eb54446be6003156158d51f4884";
  };
}
