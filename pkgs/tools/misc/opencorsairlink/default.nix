{ lib, stdenv, fetchFromGitHub, fetchpatch, libusb1, pkg-config }:

stdenv.mkDerivation rec {
  pname = "OpenCorsairLink";
  version = "unstable-2019-12-23";

  buildInputs = [ libusb1 ];
  nativeBuildInputs = [ pkg-config ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  src = fetchFromGitHub {
    owner = "audiohacked";
    repo = "OpenCorsairLink";
    rev = "46dbf206e19a40d6de6bd73142ed93bdb26c5c1a";
    sha256 = "1nizicl0mc9pslc6065mnrs0fnn8sh7ca8iiw7w9ix57zrhabpld";
  };

  patches = [
    # Pull upstream fix for -fno-common toolchain
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/audiohacked/OpenCorsairLink/commit/d600c7ff032a3911d30b039844a31f0b3acfe26a.patch";
      sha256 = "030rwka5bvf79x6ir18vqb09izhz1crp94x5gqjxwv3b20vvv4kx";
    })
  ];

  meta = with lib; {
    description = "Linux and Mac OS support for the CorsairLink Devices ";
    homepage = "https://github.com/audiohacked/OpenCorsairLink";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ lib.maintainers.expipiplus1 ];
  };
}
