{ stdenv
, lib
, autoPatchelfHook
, fetchurl
, nixosTests
, gtk3
, glfw
}:

let srcs = import ./srcs.nix { inherit fetchurl; }; in
stdenv.mkDerivation rec {
  pname = "tiltfive-control-panel";
  version = srcs.version;
  src = srcs.driver;

  buildInputs = [
    gtk3 glfw
  ];

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  installPhase = ''
    runHook preInstall

    cd tiltfive-control-panel_${version}_amd64/files/

    dest=$out/opt/tiltfive/control-panel
    pushd opt/tiltfive/control-panel

    mkdir -p $dest/data
    cp -r data/* $dest/data/

    mkdir -p $dest/lib
    install -Dm755 lib/* $dest/lib/

    install -Dm755 control_panel $dest/


    popd

    mkdir -p $out/share/applications
    install -Dm644 usr/share/applications/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace '/opt/tiltfive/control-panel/' "$dest/"

    mkdir -p $out/bin
    ln -s $dest/control_panel $out/bin/${pname}

    cp opt/tiltfive/LICENSE* $out/

    runHook postInstall
  '';

  passthru.tests.tiltfive = nixosTests.tiltfive;

  meta = with lib; {
    description = "Tilt Five™ Glasses control panel";
    homepage = "https://docs.tiltfive.com/index.html";
    # Non-redistributable. See: LICENSE.control-panel.txt, 2.1.2.
    license = with licenses; unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ q3k ];
    platforms = [ "x86_64-linux" ];
  };
}
