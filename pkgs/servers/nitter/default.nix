{ lib
, fetchFromGitHub
, nimPackages
, nixosTests
}:

nimPackages.buildNimPackage rec {
  pname = "nitter";
  version = "unstable-2022-06-04";

  src = fetchFromGitHub {
    owner = "zedeus";
    repo = "nitter";
    rev = "138826fb4fbdec73fc6fee2e025fda88f7f2fb49";
    hash = "sha256-fdzVfzmEFIej6Kb/K9MQyvbN8aN3hO7RetHL53cD59k=";
  };

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
    maintainers = with maintainers; [ erdnaxe ];
    mainProgram = "nitter";
  };

  passthru.tests = { inherit (nixosTests) nitter; };
}
