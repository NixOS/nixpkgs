{ stdenv, fetchFromGitHub, cmake, fuse, zlib, bzip2, openssl, libxml2, icu } :

stdenv.mkDerivation rec {
  name = "darling-dmg-${version}";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "darlinghq";
    repo = "darling-dmg";
    rev = "v${version}";
    sha256 = "0x285p16zfnp0p6injw1frc8krif748sfgxhdd7gb75kz0dfbkrk";
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
