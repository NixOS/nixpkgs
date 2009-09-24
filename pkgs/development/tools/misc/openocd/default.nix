{stdenv, fetchurl, libftdi}:

stdenv.mkDerivation {
  name = "openocd-0.2.0";

  src = fetchurl {
    url = "http://download.berlios.de/openocd/openocd-0.2.0.tar.bz2";
    sha256 = "1qdl2a2mxhl07xz32l9nxjvmf16b0717aqlrhd28akn6si3jps54";
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
