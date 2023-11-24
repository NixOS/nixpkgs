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
, openssl
, packedjson
, redis
, redpool
, sass
, supersnappy
, zippy
}:

buildNimPackage rec {
  pname = "nitter";
  version = "unstable-2023-10-31";

  src = fetchFromGitHub {
    owner = "zedeus";
    repo = "nitter";
    rev = "b62d73dbd373f08af07c7a79efcd790d3bc1a49c";
    hash = "sha256-yCD7FbqWZMY0fyFf9Q3Ka06nw5Ha7jYLpmPONAhEVIM=";
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
    openssl
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
