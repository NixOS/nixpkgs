{ lib, nimPackages, nixosTests, fetchFromGitHub, libsass }:

nimPackages.buildNimPackage rec {
  pname = "nitter";
  version = "unstable-2021-07-18";
  nimBinOnly = true;

  src = fetchFromGitHub {
    owner = "zedeus";
    repo = "nitter";
    rev = "6c5cb01b294d4f6e3b438fc47683359eb0fe5057";
    sha256 = "1dl8ndyv8m1hnydrp5xilcpp2cfbp02d5jap3y42i4nazc9ar6p4";
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
    frosty
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
    platforms = [ "x86_64-linux" ];
  };
}

