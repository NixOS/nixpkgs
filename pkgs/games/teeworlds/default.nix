{ fetchFromGitHub, fetchurl, stdenv, bam, pkgconfig, makeWrapper, python, alsaLib
, libX11, libGLU, SDL2, lua5_3, zlib, freetype, wavpack
}:

stdenv.mkDerivation rec {
  pname = "teeworlds";
  version = "0.7.3.1";

  src = fetchFromGitHub {
    owner = "teeworlds";
    repo = "teeworlds";
    rev = version;
    sha256 = "1hfj22xxswqnm1s74ln3dwl63rs4mk9g4yvpf75plswbxd0020la";
    fetchSubmodules = true;
  };

  postPatch = ''
    # set compiled-in DATA_DIR so resources can be found
    substituteInPlace src/engine/shared/storage.cpp \
      --replace '#define DATA_DIR "data"' \
                '#define DATA_DIR "${placeholder "out"}/share/teeworlds/data"'
  '';

  nativeBuildInputs = [ bam pkgconfig ];

  configurePhase = ''
    bam config
  '';

  buildPhase = ''
    bam conf=release
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/teeworlds
    cp build/x86_64/release/teeworlds{,_srv} $out/bin
    cp -r build/x86_64/release/data $out/share/teeworlds
  '';

  buildInputs = [
    python alsaLib libX11 libGLU SDL2 lua5_3 zlib freetype wavpack
  ];

  postInstall = ''
    mkdir -p $out/share/doc/teeworlds
    cp -v *.txt $out/share/doc/teeworlds/
  '';

  meta = {
    description = "Retro multiplayer shooter game";

    longDescription = ''
      Teeworlds is a free online multiplayer game, available for all
      major operating systems.  Battle with up to 12 players in a
      variety of game modes, including Team Deathmatch and Capture The
      Flag.  You can even design your own maps!
    '';

    homepage = https://teeworlds.com/;
    license = "BSD-style, see `license.txt'";
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = ["x86_64-linux" "i686-linux"];
  };
}
