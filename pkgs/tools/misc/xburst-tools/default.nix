{ stdenv, fetchgit, libusb, libusb1, autoconf, automake, libconfuse, pkgconfig
, gccCross ? null
}:

let
  version = "2011-12-26";
in
stdenv.mkDerivation {
  name = "xburst-tools-${version}";

  src = fetchgit {
    url = git://projects.qi-hardware.com/xburst-tools.git;
    rev = "c71ce8e15db25fe49ce8702917cb17720882e341";
    sha256 = "1hzdngs1l5ivvwnxjwzc246am6w1mj1aidcf0awh9yw0crzcjnjr";
  };

  preConfigure = ''
    sh autogen.sh
  '';

  configureFlags = stdenv.lib.optionals (gccCross != null) [
    "--enable-firmware"
    "CROSS_COMPILE=${gccCross.targetPrefix}"
  ];

  hardeningDisable = [ "pic" "stackprotector" ];

  # Not to strip cross build binaries (this is for the gcc-cross-wrapper)
  dontCrossStrip = true;

  nativeBuildInputs = [ autoconf automake pkgconfig ];
  buildInputs = [ libusb libusb1 libconfuse ] ++
    stdenv.lib.optional (gccCross != null) gccCross;

  meta = {
    description = "Qi tools to access the Ben Nanonote USB_BOOT mode";
    license = stdenv.lib.licenses.gpl3;
    homepage = http://www.linux-mtd.infradead.org/;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = stdenv.lib.platforms.x86_64;
  };
}
