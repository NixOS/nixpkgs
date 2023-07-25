{ lib
, rustPlatform
, buildNpmPackage
, fetchFromGitHub
, pkg-config
, ncurses
, sqlite
, testers
, moonfire-nvr
, breakpointHook
}:

let
  pname = "moonfire-nvr";
  version = "0.7.6";
  src = fetchFromGitHub {
    owner = "scottlamb";
    repo = "moonfire-nvr";
    rev = "v${version}";
    hash = "sha256-hPgS4Y/dD6G8lqfsJz3aeeed6P+ngJpBOng88xUc55Q=";
  };
  ui = buildNpmPackage {
    inherit version src;
    pname = "${pname}-ui";
    sourceRoot = "source/ui";
    npmDepsHash = "sha256-IpZWgMo6Y3vRn9h495ifMB3tQxobLeTLC0xXS1vrKLA=";
    installPhase = "
      runHook preInstall

      cp -r build $out

      runHook postInstall
    ";
  };
in rustPlatform.buildRustPackage {
  inherit pname version src;

  sourceRoot = "source/server";

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "hashlink-0.8.1" = "sha256-h7DEapTVy0SSTaOV9rCkdH3em4A9+PS0k1QQh1+0P4c=";
      "mp4-0.9.2" = "sha256-mJZJDzD8Ep9c+4QusyBtRoqAArHK9SLdFxG1AR7JydE=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    breakpointHook
  ];

  buildInputs = [
    ncurses
    sqlite
  ];

  postInstall = ''
    mkdir -p $out/lib/ui
    ln -s ${ui} $out/lib/ui
  '';

  doCheck = false;

  passthru = {
    inherit ui;
    tests.version = testers.testVersion {
      inherit version;
      package = moonfire-nvr;
      command = "moonfire-nvr --version";
    };
  };

  meta = with lib; {
    description = "Moonfire NVR, a security camera network video recorder";
    homepage = "https://github.com/scottlamb/moonfire-nvr";
    changelog = "https://github.com/scottlamb/moonfire-nvr/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ gaelreyrol ];
  };
}
