{ lib
, fetchFromGitHub
, nimPackages
, nixosTests
, substituteAll
, unstableGitUpdater
}:

nimPackages.buildNimPackage rec {
  pname = "nitter";
  version = "unstable-2023-07-21";

  src = fetchFromGitHub {
    owner = "zedeus";
    repo = "nitter";
    rev = "cc5841df308506356d329662d0f0c2ec4713a35c";
    hash = "sha256-QuWLoKy7suUCTYK79ghdf3o/FGFIDNyN1Iu69DFp6wg=";
  };

  patches = [
    (substituteAll {
      src = ./nitter-version.patch;
      inherit version;
      inherit (src) rev;
      url = builtins.replaceStrings [ "archive" ".tar.gz" ] [ "commit" "" ] src.url;
    })
  ];

  buildInputs = with nimPackages; [
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

  postBuild = ''
    nim c --hint[Processing]:off -r tools/gencss
    nim c --hint[Processing]:off -r tools/rendermd
  '';

  postInstall = ''
    mkdir -p $out/share/nitter
    cp -r public $out/share/nitter/public
  '';

  passthru = {
    tests = { inherit (nixosTests) nitter; };
    updateScript = unstableGitUpdater {};
  };

  meta = with lib; {
    homepage = "https://github.com/zedeus/nitter";
    description = "Alternative Twitter front-end";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ erdnaxe infinidoge ];
    mainProgram = "nitter";
  };
}
