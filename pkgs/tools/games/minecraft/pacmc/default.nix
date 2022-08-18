{ lib
, stdenvNoCC
, fetchzip
, jre
, makeWrapper
}:

stdenvNoCC.mkDerivation rec {
  pname = "pacmc";
  version = "0.5.2";

  src = fetchzip {
    url = "https://github.com/jakobkmar/pacmc/releases/download/${version}/pacmc-${version}.tar";
    sha256 = "06qskp4n9ik3pya8j61zsi0dz0h2wx1r8w9qldlyp41qrl5g8zl7";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/pacmc
    cp $src/lib/* $out/share/pacmc

    makeWrapper ${jre}/bin/java $out/bin/pacmc \
      --add-flags "-cp '$out/share/pacmc/*' net.axay.pacmc.cli.ApplicationJvmKt"

    runHook postInstall
  '';

  meta = with lib; {
    description = "An easy-to-use package manager for Minecraft mods";
    homepage = "https://github.com/jakobkmar/pacmc";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ fschwalbe ];
    platforms = jre.meta.platforms;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
  };
}
