{stdenv, fetchurl, libftdi}:

stdenv.mkDerivation {
  name = "openocd-0.4.0";

  src = fetchurl {
    url = "http://download.berlios.de/openocd/openocd-0.4.0.tar.bz2";
    sha256 = "1c9j8s3mqgw5spv6nd4lqfkd1l9jmjipi0ya054vnjfsy2617kzv";
  };


  configureFlags = [ "--enable-ft2232_libftdi" "--disable-werror" ];

  buildInputs = [ libftdi ];

  meta = {
    homepage = http://openocd.berlios.de;
    description = "Open On Chip Debugger";
    license = "GPLv2";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
