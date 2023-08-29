{ lib
, buildNimPackage
, fetchFromGitHub
, nimPackages
, nixosTests
, substituteAll
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

  src = fetchFromGitHub {
    owner = "zedeus";
    repo = "nitter";
    rev = "d7ca353a55ea3440a2ec1f09155951210a374cc7";
    hash = "sha256-nlpUzbMkDzDk1n4X+9Wk7+qQk+KOfs5ID6euIfHBoa8=";
  };

  patches = [
    (substituteAll {
      src = ./nitter-version.patch;
      inherit version;
      inherit (src) rev;
      url = builtins.replaceStrings [ "archive" ".tar.gz" ] [ "commit" "" ] src.url;
    })
  ];

  buildInputs = [
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

  nimFlags = [ "--mm:refc" ];

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
