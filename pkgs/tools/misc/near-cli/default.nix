{ lib
, mkYarnPackage
, fetchFromGitHub
, fetchYarnDeps
}:

mkYarnPackage rec {
  pname = "near-cli";
  version = "3.4.2";

  src = fetchFromGitHub {
    owner = "near";
    repo = "near-cli";
    rev = "v${version}";
    hash = "sha256-C+viNYk+6BA11cdi5GqARU3QTTONTR2B2VEZf/SeeSQ=";
  };

  packageJSON = ./package.json;

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-G/Y8xGGOlXH37Bup7mKhEaNh05GTP5CC9e/Xw4TBNMU=";
  };

  doDist = false;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/node_modules"
    mv deps/near-cli "$out/lib/node_modules"
    rm "$out/lib/node_modules/near-cli/node_modules"
    mv node_modules "$out/lib/node_modules/near-cli"

    mkdir -p "$out/bin"
    ln -s "$out/lib/node_modules/near-cli/bin/near" "$out/bin"

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/near/near-cli/blob/${src.rev}/CHANGELOG.md";
    description = "General purpose command line tools for interacting with NEAR Protocol";
    homepage = "https://github.com/near/near-cli";
    license = with lib.licenses; [ asl20 mit ];
    mainProgram = "near";
    maintainers = with lib.maintainers; [ ekleog ];
  };
}
