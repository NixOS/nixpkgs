{ fetchgit
, installShellFiles
, lib
, libftdi1
, libgpiod_1
, libjaylink
, libusb1
, pciutils
, pkg-config
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "flashrom-stable";
  version = "1.1";

  src = fetchgit {
    url = "https://review.coreboot.org/flashrom-stable";
    rev = "272aae888ce5abf5e999d750ee4577407db32246";
    hash = "sha256-DR4PAING69+TMsyycGxt1cu0ba1tTlG36+H/pJ0oP4E=";
  };

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    libftdi1
    libjaylink
    libusb1
  ] ++ lib.optionals (!stdenv.isDarwin) [
    libgpiod_1
    pciutils
  ];

  makeFlags = [ "PREFIX=$(out)" "libinstall" ] ++ lib.optionals stdenv.isDarwin [ "CONFIG_ENABLE_LIBPCI_PROGRAMMERS=no" ]
    ++ lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [ "CONFIG_INTERNAL_X86=no" "CONFIG_INTERNAL_DMI=no" "CONFIG_RAYER_SPI=0" ];

  meta = with lib; {
    homepage = "https://www.flashrom.org";
    description = "Utility for reading, writing, erasing and verifying flash ROM chips";
    license = with licenses; [ gpl2 gpl2Plus ];
    maintainers = with maintainers; [ felixsinger ];
    platforms = platforms.all;
    mainProgram = "flashrom";
  };
}
