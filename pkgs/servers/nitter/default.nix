{ lib
<<<<<<< HEAD
, buildNimPackage
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchFromGitHub
, nimPackages
, nixosTests
, substituteAll
<<<<<<< HEAD
, unstableGitUpdater
, flatty
, jester
, jsony
, karax
, markdown
, nimcrypto
, packedjson
, redis
, redpool
, sass
, supersnappy
, zippy
}:

buildNimPackage rec {
  pname = "nitter";
  version = "unstable-2023-08-08";
=======
}:

nimPackages.buildNimPackage rec {
  pname = "nitter";
  version = "unstable-2023-04-21";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "zedeus";
    repo = "nitter";
<<<<<<< HEAD
    rev = "d7ca353a55ea3440a2ec1f09155951210a374cc7";
    hash = "sha256-nlpUzbMkDzDk1n4X+9Wk7+qQk+KOfs5ID6euIfHBoa8=";
=======
    rev = "2254a0728c587ebcec51ff08da0bf145606a629e";
    hash = "sha256-d4KYBCcYbfvEtOqa1umcXmYsBRvhLgpHVoCUfY0XdXI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    (substituteAll {
      src = ./nitter-version.patch;
      inherit version;
      inherit (src) rev;
      url = builtins.replaceStrings [ "archive" ".tar.gz" ] [ "commit" "" ] src.url;
    })
  ];

<<<<<<< HEAD
  buildInputs = [
=======
  buildInputs = with nimPackages; [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    flatty
    jester
    jsony
    karax
    markdown
    nimcrypto
    packedjson
    redis
    redpool
    sass
    supersnappy
    zippy
  ];

  nimBinOnly = true;

<<<<<<< HEAD
  nimFlags = [ "--mm:refc" ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postBuild = ''
    nim c --hint[Processing]:off -r tools/gencss
    nim c --hint[Processing]:off -r tools/rendermd
  '';

  postInstall = ''
    mkdir -p $out/share/nitter
    cp -r public $out/share/nitter/public
  '';

<<<<<<< HEAD
  passthru = {
    tests = { inherit (nixosTests) nitter; };
    updateScript = unstableGitUpdater {};
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    homepage = "https://github.com/zedeus/nitter";
    description = "Alternative Twitter front-end";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ erdnaxe infinidoge ];
    mainProgram = "nitter";
  };
<<<<<<< HEAD
=======

  passthru.tests = { inherit (nixosTests) nitter; };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
