{ stdenv, kde4, cmake, protobuf, zlib, libgcrypt, fetchurl }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "cockatrice-git-b1736c75";
  src = fetchurl {
    url = https://github.com/Cockatrice/Cockatrice/archive/b1736c7599dc37ec0fda7a58e8fccf739471c8ef.tar.gz;
    sha256 = "2efdb4e951e9754a2d8a38e487bc28ba9133b894957428fef2d4628a50fbe151";
  };
  buildInputs = [ kde4.qt4 cmake protobuf zlib libgcrypt ];
  meta = {
    description = "A cross-platform virtual tabletop for multiplayer card games";
    homepage = http://www.woogerworks.com/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}