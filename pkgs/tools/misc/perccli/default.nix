{ lib
, stdenvNoCC
, fetchzip
, rpmextract
}:

stdenvNoCC.mkDerivation rec {
  pname = "perccli";
  version = "7.2110.00";

  src = fetchzip {
    # On pkg update: manually adjust the version in the URL because of the different format.
    url = "https://dl.dell.com/FOLDER09074160M/1/PERCCLI_7.211.0_Linux.tar.gz";
    sha256 = "sha256-8gk+0CrgeisfN2hNpaO1oFey57y7KuNy2i6PWTikDls=";

    # Dell seems to block "uncommon" user-agents, such as Nixpkgs's custom one.
    # Sending no user-agent at all seems to be fine though.
    curlOptsList = [ "--user-agent" "" ];
  };

  nativeBuildInputs = [ rpmextract ];

  unpackPhase = ''
    rpmextract $src/perccli-00${version}00.0000-1.noarch.rpm
  '';

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = let
    inherit (stdenvNoCC.hostPlatform) system;
    platforms = {
      x86_64-linux = ''
        install -D ./opt/MegaRAID/perccli/perccli64 $out/bin/perccli64
        ln -s perccli64 $out/bin/perccli
      '';
    };
  in platforms.${system} or (throw "unsupported system: ${system}");

  # Not needed because the binary is statically linked
  dontFixup = true;

  meta = with lib; {
    description = "Perccli Support for PERC RAID controllers";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ panicgh ];
    platforms = [ "x86_64-linux" ];
  };
}
