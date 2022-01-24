{ lib, nimPackages, nixosTests, fetchFromGitHub, libsass }:

nimPackages.buildNimPackage rec {
  pname = "nitter";
  version = "unstable-2022-01-32";
  nimBinOnly = true;

  src = fetchFromGitHub {
    owner = "zedeus";
    repo = "nitter";
    rev = "cdb4efadfeb5102b501c7ff79261fefc7327edb9";
    sha256 = "sha256-kNK0UQd1whkaZwj98b2JYtYwjUSE1qBcAYytqnSaK1o=";
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
