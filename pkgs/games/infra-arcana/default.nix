<<<<<<< HEAD
{ lib, stdenv, fetchFromGitLab, cmake, makeWrapper, SDL2, SDL2_image, SDL2_mixer
=======
{ lib
, stdenv
, fetchFromGitLab
, cmake
, makeWrapper
, SDL2
, SDL2_image
, SDL2_mixer
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "infra-arcana";
<<<<<<< HEAD
  version = "22.0.0";
=======
  version = "21.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    owner = "martin-tornqvist";
    repo = "ia";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-EFpeuzxhRriQOBtmw0D+SY6sOWGyY8iA5Xnm6PCaMX0=";
=======
    sha256 = "sha256-E2ssxdYa27qRk5cCmM7A5VqXGExwXHblR34y+rOUBRI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = [ SDL2 SDL2_image SDL2_mixer ];

<<<<<<< HEAD
=======
  # Some parts of the game don't compile with glibc 2.34. As soon as
  # this is fixed upstream we can switch to the default build flags.
  buildFlags = [ "ia" ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  installPhase = ''
    runHook preInstall

    mkdir -p $out/{opt/ia,bin}

    # Remove build artifacts
    rm -rf CMake* cmake* compile_commands.json CTest* Makefile
    cp -ra * $out/opt/ia

<<<<<<< HEAD
    # IA uses relative paths when looking for assets
=======
    # Uses relative paths when looking for assets
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    wrapProgram $out/opt/ia/ia --run "cd $out/opt/ia"
    ln -s $out/opt/ia/ia $out/bin/infra-arcana

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://sites.google.com/site/infraarcana";
    description = "A Lovecraftian single-player roguelike game";
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
