{ lib, stdenv, fetchFromGitLab, cmake, makeWrapper, SDL2, SDL2_image, SDL2_mixer
}:

stdenv.mkDerivation rec {
  pname = "infra-arcana";
  version = "22.1.0";

  src = fetchFromGitLab {
    owner = "martin-tornqvist";
    repo = "ia";
    rev = "v${version}";
    sha256 = "sha256-MI+wH0+1f41JYXT2hzDs3RrrR3eTfOzgtCa5T6m8oQc=";
  };

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = [ SDL2 SDL2_image SDL2_mixer ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{opt/ia,bin}

    # Remove build artifacts
    rm -rf CMake* cmake* compile_commands.json CTest* Makefile
    cp -ra * $out/opt/ia

    # IA uses relative paths when looking for assets
    wrapProgram $out/opt/ia/ia --run "cd $out/opt/ia"
    ln -s $out/opt/ia/ia $out/bin/infra-arcana

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://sites.google.com/site/infraarcana";
    description = "A Lovecraftian single-player roguelike game";
    mainProgram = "infra-arcana";
    longDescription = ''
      Infra Arcana is a Roguelike set in the early 20th century. The goal is to
      explore the lair of a dreaded cult called The Church of Starry Wisdom.

      Buried deep beneath their hallowed grounds lies an artifact called The
      Shining Trapezohedron - a window to all secrets of the universe. Your
      ultimate goal is to unearth this artifact.
    '';
    platforms = platforms.linux;
    maintainers = [ maintainers.kenran ];
    license = licenses.agpl3Plus;
  };
}
