{ stdenv
, lib
, fetchFromGitHub
, patchPpdFilesHook
, callPackage
}:
let
  rastertokpsl = callPackage ./rastertokpsl.nix { };
in
stdenv.mkDerivation {
  pname = "cups-kyocera";
  version = "1.1203"; # version found in PPDs

  src = fetchFromGitHub {
    owner = "veehaitch";
    repo = "kyocera-fs-1xxx";
    rev = "6f730d95b60b9249b02375525e9a58291ee89133";
    hash = "sha256-wcY4/J2nhVnVWPzBUXSiM4shw8hL7+thbd7FVvxvEPE=";
  };

  nativeBuildInputs = [ patchPpdFilesHook ];

  buildInputs = [ rastertokpsl ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/cups/model/Kyocera"
    install *.ppd "$out/share/cups/model/Kyocera/"

    runHook postInstall
  '';

  ppdFileCommands = [ "rastertokpsl" ];

  meta = with lib; {
    description = "CUPS drivers for several Kyocera FS-1xxx KPSL GDI printers";
    longDescription = ''
      Supported models include:
      - FS-1020MFP
      - FS-1025MFP
      - FS-1040
      - FS-1041
      - FS-1060DN
      - FS-1061DN
      - FS-1120MFP
      - FS-1125MFP
      - FS-1220MFP
      - FS-1320MFP
      - FS-1325MFP
    '';
    homepage = "https://global.kyocera.com";
    # Kyocera allows unmodified redistribution of the PPDs but we patch them
    license = licenses.unfree;
    maintainers = with maintainers; [ vanzef veehaitch ];
    platforms = platforms.linux;
  };
}
