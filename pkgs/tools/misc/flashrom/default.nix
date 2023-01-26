{ cmocka
, fetchurl
, fetchpatch
, stdenv
, installShellFiles
, lib
, libftdi1
, libjaylink
, libusb1
, meson
, ninja
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

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    cmocka
    libftdi1
    libusb1
    pciutils
  ] ++ lib.optional jlinkSupport libjaylink;

  # These options were reworked in the 1.3.0 release,
  # we'd instead say something like:
  #   let programmers = lib.concatStringsSep "," ([ "auto" ] ++ optional jlinkSupport [ "_jlink_" ];
  #   in "-Dprogrammer=${programmers};"
  mesonFlags = [
    (lib.strings.mesonBool "-Dconfig_jlink_spi" jlinkSupport)
  ];

  postInstall = ''
    if [ -f $src/util/flashrom_udev.rules ]; then
      install -Dm644 $src/util/flashrom_udev.rules $out/lib/udev/rules.d/flashrom.rules
    else
      install -Dm644 $src/util/z60_flashrom.rules $out/lib/udev/rules.d/flashrom.rules
    fi
    substituteInPlace $out/lib/udev/rules.d/flashrom.rules \
      --replace "plugdev" "flashrom"
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
