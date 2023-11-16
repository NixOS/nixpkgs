{ lib, fetchFromGitHub, rustPlatform, fetchYarnDeps, mkYarnPackage, darwin
, stdenv }:

let
  name = "typst-preview";
  version = "0.9.0";
  src = fetchFromGitHub {
    owner = "Enter-tainer";
    repo = name;
    rev = "v${version}";
    hash = "sha256-r/zDvfMvfvZqa3Xkzk70tIEyhc5LDwqc2A5MUuK2xC0=";
  };
  frontendSrc = "${src}/addons/frontend";
  frontend = mkYarnPackage rec {
    inherit version;
    pname = "${name}-frontend";
    src = frontendSrc;
    packageJSON = ./package.json;

    offlineCache = fetchYarnDeps {
      yarnLock = "${frontendSrc}/yarn.lock";
      hash = "sha256-7a7/UOfau84nLIAKj6Tn9rTUmeBJ7rYDFAdr55ZDLgA=";
    };

    buildPhase = ''
      runHook preBuild
      yarn --offline build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp -R deps/${pname}/dist $out
      runHook postInstall
    '';
    doDist = false;
  };

in rustPlatform.buildRustPackage rec {

  pname = name;
  inherit version src;

  buildInputs = lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks; [
      Security
      SystemConfiguration
      CoreServices
    ]);

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "hayagriva-0.4.0" = "sha256-377lXL3+TO8U91OopMYEI0NrWWwzy6+O7B65bLhP+X4=";
      "typst-0.9.0" = "sha256-+rnsUSGi3QZlbC4i8racsM4U6+l8oA9YjjUOtQAIWOk=";
      "typst-ts-compiler-0.4.0-rc9" =
        "sha256-NVmbAodDRJBJlGGDRjaEcTHGoCeN4hNjIynIDKqvNbM=";
    };
  };

  prePatch = ''
    mkdir -p addons/vscode/out/frontend
    cp -R ${frontend}/* addons/vscode/out/frontend/
  '';

  meta = with lib; {
    description = "Preview your Typst files in vscode";
    homepage = "https://github.com/Enter-tainer/typse-preview";
    license = licenses.mit;
    maintainers = with maintainers; [ berberman ];
    mainProgram = "typst-preview";
  };
}
