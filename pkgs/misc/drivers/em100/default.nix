{ lib
, stdenv
, curl
, pkg-config
, libusb
, fetchgit
}:
stdenv.mkDerivation rec {
  pname = "em100";
  version = "unstable-2022-05-02-86631c9";   # upstream does not appear to have formal releases
  src = fetchgit {
    url  = "https://review.coreboot.org/em100";
    rev  = "7cd8c935239ab63ea7dd583183d8144e38c42186";
    hash = "sha256-zKRVhqNHtgVj6JDkTV+6GEjmM1FICqQr286uTXwUvpo=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libusb
    curl    # for optionally downloading firmware images
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -m 750 em100 $out/bin/em100
    mkdir -p $out/lib/udev/rules.d/
    install -m 644 60-dediprog-em100pro.rules $out/lib/udev/rules.d/
    runHook postInstall
    '';

  meta = with lib; {
    homepage = "https://www.coreboot.org/EM100pro";
    description = "Allows operating a Dediprog EM100Pro SPI NOR Flash Emulator";
    longDescription =  # copied from README
      ''
      This tool supports using the Dediprog EM100-Pro [1] in Linux. It supports both
      the original version and the new -G2 variant.

      The 'em100' device provides a way to emulate a SPI-flash chip. Various
      connectors are available to allow it to take over from the in-circuit SPI chip
      so that the SoC sees the em100's internal memory as the contents of the SPI
      flash. Images can be loaded into the em100 over USB in a few seconds, thus
      providing a much faster development cycle than is possible by reprogramming
      the SPI flash each time.

      Major features provided by the tool include:

      - Set the chip being emulated (the tool supports about 600)
      - Adjust the state of the hold pin, which supports overriding the internal SPI
      - Use of several em100 devices, distinguished by their serial number
      - Terminal mode, allowing the SoC to send messages
      - Output a trace of SPI commands issued by the SoC
      - Reading / writing em100 firmware (dangerous as it can brick your em100)

      [1] https://www.dediprog.com/product/EM100Pro-G2
      '';
    license = licenses.gpl2Plus;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    maintainers = with maintainers; [ amjoseph ];
    platforms = platforms.all;
  };
}
