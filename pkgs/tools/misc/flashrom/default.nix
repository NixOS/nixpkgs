{ fetchurl
, fetchpatch
, stdenv
, installShellFiles
, lib
, libftdi1
, libjaylink
, libusb1
, pciutils
, pkg-config
, jlinkSupport ? false
}:

stdenv.mkDerivation rec {
  pname = "flashrom";
  version = "1.2.1";

  src = fetchurl {
    url = "https://download.flashrom.org/releases/flashrom-v${version}.tar.bz2";
    hash = "sha256-iaf/W+sIyJuHlbvSU6UblFNUeoZMMXkzAilrVrvFbWU=";
  };

  nativeBuildInputs = [ pkg-config installShellFiles ];
  buildInputs = [ libftdi1 libusb1 pciutils ]
    ++ lib.optional jlinkSupport libjaylink;

  postPatch = ''
    substituteInPlace util/z60_flashrom.rules \
      --replace "plugdev" "flashrom"
  '';

  makeFlags = [ "PREFIX=$(out)" "libinstall" ]
    ++ lib.optional jlinkSupport "CONFIG_JLINK_SPI=yes";

  postInstall = ''
    install -Dm644 util/z60_flashrom.rules $out/lib/udev/rules.d/flashrom.rules
  '';

  meta = with lib; {
    homepage = "https://www.flashrom.org";
    description = "Utility for reading, writing, erasing and verifying flash ROM chips";
    license = licenses.gpl2;
    maintainers = with maintainers; [ fpletz felixsinger ];
    platforms = platforms.all;
    broken = stdenv.isDarwin; # requires DirectHW
  };
}
