{ fetchurl
, gcc9Stdenv
, installShellFiles
, lib
, libftdi1
, libjaylink
, libusb1
, pciutils
, pkg-config
, jlinkSupport ? false
}:

gcc9Stdenv.mkDerivation rec {
  pname = "flashrom";
  version = "1.2";

  src = fetchurl {
    url = "https://download.flashrom.org/releases/flashrom-v${version}.tar.bz2";
    sha256 = "0ax4kqnh7kd3z120ypgp73qy1knz47l6qxsqzrfkd97mh5cdky71";
  };

  nativeBuildInputs = [ pkg-config installShellFiles ];
  buildInputs = [ libftdi1 libusb1 ]
    # https://github.com/flashrom/flashrom/issues/125
    ++ lib.optional (!gcc9Stdenv.isAarch64) pciutils
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
    maintainers = with maintainers; [ funfunctor fpletz felixsinger ];
    platforms = platforms.all;
    broken = gcc9Stdenv.isDarwin; # requires DirectHW
  };
}
