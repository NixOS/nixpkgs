{ lib, bzip2, fetchurl, makeWrapper, coreutils, gnused, openjdk, stdenv }:
stdenv.mkDerivation rec {
  pname = "forge-mtg";
  version = "1.6.53";

  src = fetchurl {
    url = "https://releases.cardforge.org/forge/forge-gui-desktop/${version}/forge-gui-desktop-${version}.tar.bz2";
    sha256 = "sha256-rRb4PevxKMw4GN0q1oMRRsXQfgZhrNrJ3S++CuctRvA=";
  };
  sourceRoot = ".";

  dontBuild = true;

  nativeBuildInputs = [ bzip2 makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -vp $out/{bin,share/forge}
    cp -var . $out/share/forge
    runHook postInstall
  '';
  preFixup = ''
    for commandToInstall in forge forge-adventure; do
      chmod 555 $out/share/forge/$commandToInstall.sh
      makeWrapper $out/share/forge/$commandToInstall.sh $out/bin/$commandToInstall \
        --prefix PATH : ${lib.makeBinPath [ coreutils openjdk gnused ]} \
        --set JAVA_HOME ${openjdk}/lib/openjdk
    done
  '';

  meta = with lib; {
    description = "Magic: the Gathering card game with rules enforcement";
    homepage = "https://www.slightlymagic.net/forum/viewforum.php?f=26";
    platforms = openjdk.meta.platforms;
    license = licenses.gpl3Plus;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    maintainers = with maintainers; [ eigengrau ];
  };
}
