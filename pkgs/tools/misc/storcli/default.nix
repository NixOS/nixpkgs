{ lib
, stdenvNoCC
, fetchurl
, rpmextract
, unzip
}:
stdenvNoCC.mkDerivation rec {
  pname = "storcli";
  version = "7.2106.00";

  src = fetchurl {
    url = "https://docs.broadcom.com/docs-and-downloads/raid-controllers/raid-controllers-common-files/00${version}00.0000_Unified_StorCLI.zip";
    sha256 = "sha256-sRMpNXCdcysliVQwRE/1yAeU/cp+y0f2F8BPiWyotxQ=";
  };

  nativeBuildInputs = [ rpmextract unzip ];

  buildCommand = ''
    unzip $src
    rpmextract Unified_storcli_all_os/Linux/storcli-*.noarch.rpm
    install -D ./opt/MegaRAID/storcli/storcli64 $out/bin/storcli64
    ln -s storcli64 $out/bin/storcli

    # Not needed because the binary is statically linked
    #eval fixupPhase
  '';

  meta = with lib; {
    description = "Storage Command Line Tool";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ panicgh ];
    platforms = with platforms; intersectLists x86_64 linux;
  };
}
