{ lib, nimPackages, nixosTests, fetchFromGitHub, libsass }:

nimPackages.buildNimPackage rec {
  pname = "nitter";
  version = "unstable-2022-05-13";
  nimBinOnly = true;

  src = fetchFromGitHub {
    owner = "zedeus";
    repo = "nitter";
    rev = "683c052036b268028f0ecae020a1519bc586516d";
    sha256 = "179z66jlwbdarrgvpdh8aqy2ihkiakd22wqydrfgpsgr59ma8fgl";
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
    nim c --hint[Processing]:off -r tools/rendermd
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
