{ stdenv, lib, fetchFromGitHub, pkg-config, allegro5, libGL, wrapGAppsHook3 }:

stdenv.mkDerivation rec {
  pname = "liberation-circuit";
  version = "1.3-unstable-2022-01-02";

  src = fetchFromGitHub {
    owner = "linleyh";
    repo = "liberation-circuit";
    rev = "19e3363547793e931fd9419b61ebc2cd8e257714";
    hash = "sha256-zIwjh4CBSmKz7pF7GM5af+VslWho5jHOLsulbW4C8TY=";
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook3 ];
  buildInputs = [ allegro5 libGL ];

  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt
    cp -r bin $out/opt/liberation-circuit
    chmod +x $out/opt/liberation-circuit/launcher.sh

    install -D linux-packaging/liberation-circuit.desktop $out/share/applications/liberation-circuit.desktop
    install -D linux-packaging/liberation-circuit.appdata.xml $out/share/metainfo/liberation-circuit.appdata.xml
    install -D linux-packaging/icon-256px.png $out/share/pixmaps/liberation-circuit.png

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/opt/liberation-circuit/launcher.sh $out/bin/liberation-circuit \
      "''${gappsWrapperArgs[@]}"
  '';

  meta = {
    description = "Real-time strategy game with programmable units";
    mainProgram = "liberation-circuit";
    longDescription = ''
      Escape from a hostile computer system!
      Harvest data to create an armada of battle-processes to aid your escape!
      Take command directly and play the game as an RTS, or use the game's built-in
      editor and compiler to write your own unit AI in a simplified version of C.
    '';
    homepage = "https://linleyh.itch.io/liberation-circuit";
    maintainers = with lib.maintainers; [ emilytrau ];
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
