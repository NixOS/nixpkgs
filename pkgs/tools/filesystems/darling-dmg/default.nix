{ stdenv, fetchFromGitHub, lib, cmake, fuse, zlib, bzip2, openssl, libxml2, icu } :

stdenv.mkDerivation rec {
  name = "darling-dmg-${version}";
  version = "1.0";
  src = fetchFromGitHub {
    owner = "darlinghq";
    repo = "darling-dmg";
    rev = "9522e3907b82f6cde141b3e0e0063f09c8710cbf";
    sha256 = "5d968b0609f9bfbecc26753d21b5182e15183b672967f7dec6038404cd6a6d7f";
  };
  buildInputs = [ cmake fuse openssl zlib bzip2 libxml2 icu ];
  cmakeConfigureFlagFlags = ["-DCMAKE_BUILD_TYPE=RELEASE"];
  meta = {
    homepage = http://www.darlinghq.org/;
    description = "Darling lets you open OS X dmgs on Linux";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl3;
  };
}
