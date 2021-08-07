{ lib
, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, libftdi1
, libusb1
, pciutils
, installShellFiles
}:

stdenv.mkDerivation rec {
  pname = "flashrom";
  version = "1.2";

  src = fetchurl {
    url = "https://download.flashrom.org/releases/flashrom-v${version}.tar.bz2";
    sha256 = "0ax4kqnh7kd3z120ypgp73qy1knz47l6qxsqzrfkd97mh5cdky71";
  };

  postPatch = ''
    substituteInPlace util/z60_flashrom.rules \
      --replace "plugdev" "flashrom"
  '';

  # Meson build doesn't build and install manpage. Only Makefile can.
  # Build manpage from source directory. Here we're inside the ./build subdirectory
  postInstall = ''
    make flashrom.8 -C ..
    installManPage ../flashrom.8
    install -Dm644 ../util/z60_flashrom.rules $out/etc/udev/rules.d/flashrom.rules
  '';

  mesonFlags = lib.optionals stdenv.isAarch64 [ "-Dpciutils=false" ];
  nativeBuildInputs = [ meson pkg-config ninja installShellFiles ];
  buildInputs = [ libftdi1 libusb1 pciutils ];

  meta = with lib; {
    homepage = "http://www.flashrom.org";
    description = "Utility for reading, writing, erasing and verifying flash ROM chips";
    license = licenses.gpl2;
    maintainers = with maintainers; [ funfunctor fpletz felixsinger ];
    platforms = platforms.all;
    broken = stdenv.isDarwin; # requires DirectHW
  };
}
