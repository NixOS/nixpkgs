{ lib, nimPackages, nixosTests, fetchFromGitHub, libsass }:

nimPackages.buildNimPackage rec {
  pname = "nitter";
  version = "unstable-2022-02-11";
  nimBinOnly = true;

  src = fetchFromGitHub {
    owner = "zedeus";
    repo = "nitter";
    rev = "6695784050605c77a301c0a66764fa9a9580a2f5";
    sha256 = "1lddzf6m74bw5kkv465cp211xxqbwnfacav7ia3y9i38rrnqwk6m";
  };

  buildInputs = with nimPackages; [
    jester
    karax
    sass
    nimcrypto
    markdown
    packedjson
    supersnappy
    redpool
    redis
    zippy
    flatty
    jsony
  ];

  postBuild = ''
    nim c --hint[Processing]:off -r tools/gencss
  '';

  postInstall = ''
    mkdir -p $out/share/nitter
    cp -r public $out/share/nitter/public
  '';

  passthru.tests = { inherit (nixosTests) nitter; };

  meta = with lib; {
    description = "Alternative Twitter front-end";
    homepage = "https://github.com/zedeus/nitter";
    maintainers = with maintainers; [ erdnaxe ];
    license = licenses.agpl3Only;
    mainProgram = "nitter";
  };
}
