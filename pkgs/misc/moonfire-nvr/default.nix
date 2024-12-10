{
  lib,
  stdenv,
  rustPlatform,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  ncurses,
  sqlite,
  testers,
  moonfire-nvr,
  darwin,
}:

let
  pname = "moonfire-nvr";
  version = "0.7.7";
  src = fetchFromGitHub {
    owner = "scottlamb";
    repo = "moonfire-nvr";
    rev = "v${version}";
    hash = "sha256-+7VahlS+NgaO2knP+xqdlZnNEfjz8yyF/VmjWf77KXI=";
  };
  ui = buildNpmPackage {
    inherit version src;
    pname = "${pname}-ui";
    sourceRoot = "${src.name}/ui";
    npmDepsHash = "sha256-IpZWgMo6Y3vRn9h495ifMB3tQxobLeTLC0xXS1vrKLA=";
    installPhase = ''
      runHook preInstall

      cp -r build $out

      runHook postInstall
    '';
  };
in
rustPlatform.buildRustPackage {
  inherit pname version src;

  sourceRoot = "${src.name}/server";

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "coded-0.2.0-pre" = "sha256-ICDvLFCsiPCzAzf3nrRhH/McNPVQz1+uVOmj6Uc5teg=";
      "hashlink-0.8.1" = "sha256-h7DEapTVy0SSTaOV9rCkdH3em4A9+PS0k1QQh1+0P4c=";
      "mp4-0.9.2" = "sha256-mJZJDzD8Ep9c+4QusyBtRoqAArHK9SLdFxG1AR7JydE=";
    };
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      ncurses
      sqlite
    ]
    ++ lib.optionals stdenv.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        Security
      ]
    );

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
    mainProgram = "moonfire-nvr";
  };
}
