{ stdenv, fetchFromGithub, cmake, pkgconfig, libgcrypt, libuuid, devicemapper, libudev, openssl, libgpgerror }:

stdenv.mkDerivation rec {
  name = "tcplay-2.0";

  src = fetchFromGithub {
    owner = "bwalex";
    repo = "tc-play";
    rev = "v2.0";
    sha256 = "0bg46ijjdzrfy5yv090sh6rf5wyrpdias2xiciip8qp86w7qj5qf";
  };

  buildInputs = [ cmake pkgconfig libgcrypt libuuid devicemapper libudev openssl libgpgerror ];

  configurePhase = ''
    mkdir objdir
    cd objdir
    cmake -DCMAKE_INSTALL_PREFIX=$out ..
  '';

  NIX_CFLAGS_COMPILE = "-fPIC";

  meta = {
    description = "Free and simple TrueCrypt Implementation based on dm-crypt";
    license = stdenv.lib.licenses.bsd2;
  };
}
