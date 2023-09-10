{ lib
, stdenvNoCC
, fetchzip
, rpmextract
}:

stdenvNoCC.mkDerivation rec {
  pname = "storcli";
  version = "7.2309.00";

  src = fetchzip {
    url = "https://docs.broadcom.com/docs-and-downloads/raid-controllers/raid-controllers-common-files/Unified_storcli_all_os_${version}00.0000.zip";
    sha256 = "sha256-n2MzT2LHLHWMWhshWXJ/Q28w9EnLrW6t7hLNveltxLo=";
  };

  nativeBuildInputs = [ rpmextract ];

  unpackPhase = let
    inherit (stdenvNoCC.hostPlatform) system;
    platforms = {
      x86_64-linux = "Linux";
      aarch64-linux = "ARM/Linux";
    };
    platform = platforms.${system} or (throw "unsupported system: ${system}");
  in ''
    rpmextract $src/${platform}/storcli-00${version}00.0000-1.*.rpm
  '';

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    install -D ./opt/MegaRAID/storcli/storcli64 $out/bin/storcli64
    ln -s storcli64 $out/bin/storcli
  '';

  # Not needed because the binary is statically linked
  dontFixup = true;

  meta = with lib; {
    # Unfortunately there is no better page for this.
    # Filter for downloads, set 100 items per page. Sort by newest does not work.
    # Then search manually for the latest version.
    homepage = "https://www.broadcom.com/site-search?q=storcli";
    description = "Storage Command Line Tool";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ panicgh ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
