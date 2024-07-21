{
  lib,
  fetchzip,
  stdenvNoCC,
  makeWrapper,
}:
let
  build = "520";
in
stdenvNoCC.mkDerivation rec {
  pname = "swiftbar";
  version = "2.0.0";

  src = fetchzip {
    url = "https://github.com/swiftbar/SwiftBar/releases/download/v${version}/SwiftBar.v${version}.b${build}.zip";
    hash = "sha256-eippK01Q+J9jdwvnGcnr7nw3KwyQQqh051lHN3Xmy+c=";
    stripRoot = false;
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{Applications,bin}
    cp -r ./SwiftBar.app $out/Applications

    # Symlinking doesnt work; The auto-updater will fail to start which renders the app useless
    makeWrapper $out/Applications/SwiftBar.app/Contents/MacOS/SwiftBar $out/bin/SwiftBar

    runHook postInstall
  '';

  meta = with lib; {
    description = "Powerful macOS menu bar customization tool";
    homepage = "https://swiftbar.app";
    changelog = "https://github.com/swiftbar/SwiftBar/releases/tag/v${version}";
    mainProgram = "SwiftBar";
    license = licenses.mit;
    platforms = platforms.darwin;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ matteopacini ];
  };
}
