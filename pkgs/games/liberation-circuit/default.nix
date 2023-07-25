{ stdenv, lib, fetchFromGitHub, fetchurl, pkg-config, makeWrapper, allegro5, libGL }:

stdenv.mkDerivation rec {
  pname = "liberation-circuit";
  version = "unstable-2022-01-02";

  src = fetchFromGitHub {
    owner = "linleyh";
    repo = pname;
    rev = "19e3363547793e931fd9419b61ebc2cd8e257714";
    sha256 = "zIwjh4CBSmKz7pF7GM5af+VslWho5jHOLsulbW4C8TY=";
  };

  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = [ allegro5 libGL ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt
    cp -r bin $out/opt/liberation-circuit
    chmod +x $out/opt/liberation-circuit/launcher.sh
    makeWrapper $out/opt/liberation-circuit/launcher.sh $out/bin/liberation-circuit

    install -D linux-packaging/liberation-circuit.desktop $out/share/applications/liberation-circuit.desktop
    install -D linux-packaging/liberation-circuit.appdata.xml $out/share/metainfo/liberation-circuit.appdata.xml
    install -D linux-packaging/icon-256px.png $out/share/pixmaps/liberation-circuit.png

    runHook postInstall
  '';

  meta = with lib; {
    description = "Real-time strategy game with programmable units";
    longDescription = ''
      Escape from a hostile computer system! Harvest data to create an armada of battle-processes to aid your escape! Take command directly and play the game as an RTS, or use the game's built-in editor and compiler to write your own unit AI in a simplified version of C.
    '';
    homepage = "https://linleyh.itch.io/liberation-circuit";
    maintainers = with maintainers; [ emilytrau ];
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}
