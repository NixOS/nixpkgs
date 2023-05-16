{ lib
, stdenvNoCC
, fetchFromGitHub
, makeWrapper
<<<<<<< HEAD
, babashka-unwrapped
=======
, babashka
, graalvm17-ce
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenvNoCC.mkDerivation rec {
  pname = "bbin";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "babashka";
    repo = "bbin";
    rev = "v${version}";
    sha256 = "sha256-5hohAr6a8C9jPwhQi3E66onSa6+P9plS939fQM/fl9Q=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D bbin $out/bin/bbin
    mkdir -p $out/share
    cp -r docs $out/share/docs
    wrapProgram $out/bin/bbin \
<<<<<<< HEAD
      --prefix PATH : "${lib.makeBinPath [ babashka-unwrapped babashka-unwrapped.graalvmDrv ]}"
=======
      --prefix PATH : "${lib.makeBinPath [ babashka babashka.graalvmDrv ]}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/babashka/bbin";
    description = "Install any Babashka script or project with one command";
    license = licenses.mit;
<<<<<<< HEAD
    inherit (babashka-unwrapped.meta) platforms;
=======
    inherit (babashka.meta) platforms;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ sohalt ];
  };
}
