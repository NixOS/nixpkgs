{ stdenv, lib, fetchFromGitHub, fetchurl, cmake, git, makeWrapper, allegro5, libGL }:

stdenv.mkDerivation rec {
  pname = "liberation-circuit";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "linleyh";
    repo = pname;
    rev = "v${version}";
    sha256 = "BAv0wEJw4pK77jV+1bWPHeqyU/u0HtZLBF3ETUoQEAk=";
  };

  patches = [
    # Linux packaging assets
    (fetchurl {
      url = "https://github.com/linleyh/liberation-circuit/commit/72c1f6f4100bd227540aca14a535e7f4ebdeb851.patch";
      sha256 = "0sad1z1lls0hanv88g1q6x5qr4s8f5p42s8j8v55bmwsdc0s5qys";
    })
  ];

  # Hack to make binary diffs work
  prePatch = ''
    function patch {
      git apply --whitespace=nowarn "$@"
    }
  '';

  postPatch = ''
    unset -f patch
    substituteInPlace bin/launcher.sh --replace ./libcirc ./liberation-circuit
  '';

  nativeBuildInputs = [ cmake git makeWrapper ];
  buildInputs = [ allegro5 libGL ];

  cmakeFlags = [
    "-DALLEGRO_LIBRARY=${lib.getDev allegro5}"
    "-DALLEGRO_INCLUDE_DIR=${lib.getDev allegro5}/include"
  ];

  NIX_CFLAGS_LINK = "-lallegro_image -lallegro_primitives -lallegro_color -lallegro_acodec -lallegro_audio -lallegro_dialog -lallegro_font -lallegro_main -lallegro -lm";
  hardeningDisable = [ "format" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt
    cd ..
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
