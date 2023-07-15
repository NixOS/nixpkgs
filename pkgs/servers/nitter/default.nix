{ lib
, fetchFromGitHub
, nimPackages
, nixosTests
, substituteAll
}:

nimPackages.buildNimPackage rec {
  pname = "nitter";
  version = "unstable-2023-07-10";

  src = fetchFromGitHub {
    owner = "zedeus";
    repo = "nitter";
    rev = "0bc3c153d9b38a3c02f321fb64a375fef6b97e8e";
    hash = "sha256-msx14FZl2uRZvZjTlF7c3Va742HhiU6R2jdh4neIEV4=";
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

  meta = with lib; {
    homepage = "https://github.com/zedeus/nitter";
    description = "Alternative Twitter front-end";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ erdnaxe infinidoge ];
    mainProgram = "nitter";
  };

  passthru.tests = { inherit (nixosTests) nitter; };
}
