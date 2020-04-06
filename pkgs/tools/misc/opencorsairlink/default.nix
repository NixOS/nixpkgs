{ stdenv, fetchFromGitHub, libusb1, pkgconfig }:

stdenv.mkDerivation rec {
  name = "OpenCorsairLink-${version}";
  version = "2019-12-23";

  buildInputs = [ libusb1 ];
  nativeBuildInputs = [ pkgconfig ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  src = fetchFromGitHub {
    owner = "audiohacked";
    repo = "OpenCorsairLink";
    rev = "46dbf206e19a40d6de6bd73142ed93bdb26c5c1a";
    sha256 = "1nizicl0mc9pslc6065mnrs0fnn8sh7ca8iiw7w9ix57zrhabpld";
  };

  meta = with stdenv.lib; {
    description = "Linux and Mac OS support for the CorsairLink Devices ";
    homepage = "https://github.com/audiohacked/OpenCorsairLink";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ stdenv.lib.maintainers.expipiplus1 ];
  };
}
