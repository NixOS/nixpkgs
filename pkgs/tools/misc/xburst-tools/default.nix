{ stdenv, fetchgit, libusb, libusb1, autoconf, automake, confuse, pkgconfig
, gccCross ? null }:

let
  version = "2011-12-26";
in
stdenv.mkDerivation {
  name = "xburst-tools-${version}";

  src = fetchgit {
    url = git://projects.qi-hardware.com/xburst-tools.git;
    rev = "c71ce8e15db25fe49ce8702917cb17720882e341";
    sha256 = "abe4c4591183f2bc5ca6363451d1cd7d966c080b4f5bfb0fedf7e9a4f70267a4";
  };

  preConfigure = ''
    sh autogen.sh
  '';

  configureFlags = if gccCross != null then
    "--enable-firmware CROSS_COMPILE=${gccCross.crossConfig}-"
    else "";

  # Not to strip cross build binaries (this is for the gcc-cross-wrapper)
  dontCrossStrip = true;

  buildNativeInputs = [ pkgconfig ];
  buildInputs = [ libusb libusb1 autoconf automake confuse ] ++
    stdenv.lib.optional (gccCross != null) gccCross;

  meta = {
    description = "Qi tools to access the Ben Nanonote USB_BOOT mode";
    license = "GPLv3";
    homepage = http://www.linux-mtd.infradead.org/;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
