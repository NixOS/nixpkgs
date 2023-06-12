{ curl
, fetchgit
, lib
, libusb1
, pkg-config
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "em100";
  version = "unstable-2023-06-12";

  src = fetchgit {
    url = "https://review.coreboot.org/em100";
    rev = "a1d938f8b4253c76fb31e69de33266cb71bda141";
    hash = "sha256-jkgdUKAQlg04fwVGw94JorwAKiJcgDbYtcQvAI2BepI=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    curl
    libusb1
  ];

  buildPhase = ''
    runHook preBuild
    make em100
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 em100 $out/bin/em100
    install -Dm644 60-dediprog-em100pro.rules $out/lib/udev/rules.d/dediprog_em100.rules
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.coreboot.org";
    description = "Open source tool for the EM100 SPI flash emulator";
    license = licenses.gpl2;
    maintainers = with maintainers; [ felixsinger ];
    platforms = platforms.linux;
  };
}
