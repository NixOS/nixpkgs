{ stdenv, fetchgit, libusb, autoconf, automake, confuse
, gccCross ? null }:

let
  version = "2011-03-08";
in
stdenv.mkDerivation {
  name = "xburst-tools-${version}";

  src = fetchgit {
    url = git://projects.qi-hardware.com/xburst-tools.git;
    rev = "a3a38cabf1e854667d90f49f0b4487e28974a3a6";
    sha256 = "ac5671708cf9d18de79207530335f6781fa4bedf55288069786f4ecb971c4658";
  };

  preConfigure = ''
    sh autogen.sh
  '';

  configureFlags = if gccCross != null then
    "--enable-firmware CROSS_COMPILE=${gccCross.crossConfig}-"
    else "";

  # Not to strip cross build binaries (this is for the gcc-cross-wrapper)
  dontCrossStrip = true;

  buildInputs = [ libusb autoconf automake confuse ] ++
    stdenv.lib.optional (gccCross != null) gccCross;

  meta = {
    description = "Qi tools to access the Ben Nanonote USB_BOOT mode";
    license = "GPLv3";
    homepage = http://www.linux-mtd.infradead.org/;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
