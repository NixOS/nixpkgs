{ lib, nimPackages, nixosTests, fetchFromGitHub, libsass }:

nimPackages.buildNimPackage rec {
  pname = "nitter";
  version = "unstable-2022-03-21";
  nimBinOnly = true;

  src = fetchFromGitHub {
    owner = "zedeus";
    repo = "nitter";
    rev = "6884f05041a9b8619ec709afacdfdd6482a120a0";
    sha256 = "1mnc6jqljpqp9lgcrxxvf3aiswssr34v139cxfbwlmj45swmsazh";
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
