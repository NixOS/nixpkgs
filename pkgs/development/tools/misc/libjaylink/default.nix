{ stdenv, fetchgit, autoreconfHook, pkgconfig, libusb }:
stdenv.mkDerivation {
  name = "libjaylink-0.1.0";

  src = fetchgit {
    url = "git://git.zapb.de/libjaylink.git";
    rev = "aee8ed0d9449a2157b1f19ba1a0de0992593d803";
    sha256 = "1qjy8zis7pz070z54fjrrjb8il76rxdc4s61qx6gr8wdanrspldg";
  };

  buildInputs = [ autoreconfHook pkgconfig libusb ];

  meta = with stdenv.lib; {
    description = "Shared library written in C to access SEGGER J-Link and compatible devices";
    homepage = http://git.zapb.de/libjaylink.git;
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ elitak ];
  };
}
