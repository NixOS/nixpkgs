{ fetchurl
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
  version = "1.3.0";

  src = fetchurl {
    url = "https://download.flashrom.org/releases/flashrom-v${version}.tar.bz2";
    hash = "sha256-oFMjRFPM0BLnnzRDvcxhYlz5e3/Xy0zdi/v/vosUliM=";
  };

  nativeBuildInputs = [ pkg-config installShellFiles ];
  buildInputs = [ libftdi1 libusb1 ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ pciutils ]
    ++ lib.optional jlinkSupport libjaylink;

  postPatch = ''
    substituteInPlace util/flashrom_udev.rules \
      --replace 'GROUP="plugdev"' 'TAG+="uaccess", TAG+="udev-acl"'
  '';

  makeFlags = [ "PREFIX=$(out)" "libinstall" ]
    ++ lib.optional jlinkSupport "CONFIG_JLINK_SPI=yes"
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [ "CONFIG_INTERNAL_X86=no" "CONFIG_INTERNAL_DMI=no" "CONFIG_RAYER_SPI=no" ];

  postInstall = ''
    install -Dm644 util/flashrom_udev.rules $out/lib/udev/rules.d/flashrom.rules
  '';

  meta = with lib; {
    homepage = "https://www.flashrom.org";
    description = "Utility for reading, writing, erasing and verifying flash ROM chips";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fpletz felixsinger ];
    platforms = platforms.all;
    mainProgram = "flashrom";
  };
}
