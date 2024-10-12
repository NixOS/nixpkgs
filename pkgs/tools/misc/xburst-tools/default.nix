{ lib, stdenv, fetchgit, libusb-compat-0_1, libusb1, autoconf, automake, libconfuse, pkg-config
, gccCross ? null
}:

let
  version = "2011-12-26";
in
stdenv.mkDerivation {
  pname = "xburst-tools";
  inherit version;

  src = fetchgit {
    url = "git://projects.qi-hardware.com/xburst-tools.git";
    rev = "c71ce8e15db25fe49ce8702917cb17720882e341";
    sha256 = "1hzdngs1l5ivvwnxjwzc246am6w1mj1aidcf0awh9yw0crzcjnjr";
  };

  preConfigure = ''
    sh autogen.sh
  '';

  # Workaround build failure on -fno-common toolchains:
  #   mipsel-unknown-linux-uclibc-ld: boothandler.o:(.bss+0x8): multiple definition of
  #     `start_addr'; main.o:(.bss+0x8): first defined here
  NIX_CFLAGS_COMPILE_FOR_TARGET = "-fcommon";

  configureFlags = lib.optionals (gccCross != null) [
    "--enable-firmware"
    "CROSS_COMPILE=${gccCross.targetPrefix}"
  ];

  hardeningDisable = [ "pic" "stackprotector" ];

  # Not to strip cross build binaries (this is for the gcc-cross-wrapper)
  dontCrossStrip = true;

  nativeBuildInputs = [ autoconf automake pkg-config ];
  buildInputs = [ libusb-compat-0_1 libusb1 libconfuse ] ++
    lib.optional (gccCross != null) gccCross;

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Qi tools to access the Ben Nanonote USB_BOOT mode";
    license = lib.licenses.gpl3;
    homepage = "http://www.linux-mtd.infradead.org/";
    maintainers = [ ];
    platforms = lib.platforms.x86_64;
  };
}
