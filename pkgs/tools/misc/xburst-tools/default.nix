{ stdenv, fetchgit, libusb, autoconf, automake, confuse
, gccCross ? null }:

let
  version = "2011-04-08";
in
stdenv.mkDerivation {
  name = "xburst-tools-${version}";

  src = fetchgit {
    url = git://projects.qi-hardware.com/xburst-tools.git;
    rev = "c070928faee41f36920a035eef0dbcabdfa8a2bb";
    sha256 = "66ea1a81b71bad599d76691f07a986f9bb2ccecf397e8486b661d8baace3460e";
  };

  prePatch = ''
    find . -name Makefile* -exec sed -i \
      -e s/mipsel-openwrt-linux-/mipsel-unknown-linux-/ {} \;
  '';

  patches = [ ./gcc-4.4.patch ];

  preConfigure = ''
    sh autogen.sh
  '';

  configureFlags = if gccCross != null then "--enable-firmware" else "";

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
