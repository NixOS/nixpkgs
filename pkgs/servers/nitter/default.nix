{ lib
, fetchFromGitHub
, nimPackages
, nixosTests
, substituteAll
}:

nimPackages.buildNimPackage rec {
  pname = "nitter";
  version = "unstable-2023-04-21";

  src = fetchFromGitHub {
    owner = "zedeus";
    repo = "nitter";
    rev = "2254a0728c587ebcec51ff08da0bf145606a629e";
    hash = "sha256-d4KYBCcYbfvEtOqa1umcXmYsBRvhLgpHVoCUfY0XdXI=";
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
