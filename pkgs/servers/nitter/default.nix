{ lib, nimPackages, nixosTests, fetchFromGitHub, libsass }:

nimPackages.buildNimPackage rec {
  pname = "nitter";
  version = "unstable-2021-12-31";
  nimBinOnly = true;

  src = fetchFromGitHub {
    owner = "zedeus";
    repo = "nitter";
    rev = "9d117aa15b3c3238cee79acd45d655eeb0e46293";
    sha256 = "06hd3r1kgxx83sl5ss90r39v815xp2ki72fc8p64kid34mcn57cz";
  };

  buildInputs = with nimPackages; [
    jester
    karax
    sass
    regex
    unicodedb
    unicodeplus
    segmentation
    nimcrypto
    markdown
    packedjson
    supersnappy
    redpool
    flatty
    zippy
    redis
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
