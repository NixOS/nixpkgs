{ lib, buildGoModule, fetchFromGitHub, mage, writeShellScriptBin, nixosTests }:

buildGoModule rec {
  pname = "vikunja-api";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "go-vikunja";
    repo = "api";
    rev = "v${version}";
    hash = "sha256-tYhlAF1VuM/Xz4HP7DtI0hGsiNyYxzFiNIEbm8n9DC8=";
  };

  nativeBuildInputs =
    let
      fakeGit = writeShellScriptBin "git" ''
        if [[ $@ = "describe --tags --always --abbrev=10" ]]; then
            echo "${version}"
        else
            >&2 echo "Unknown command: $@"
            exit 1
        fi
      '';
    in
    [ fakeGit mage ];

  vendorHash = "sha256-OD/7RCCrRdlrsRW7CRT01cDUvNnedNdTZ8YgDFGaE4o=";

  # checks need to be disabled because of needed internet for some checks
  doCheck = false;

  buildPhase = ''
    runHook preBuild

    # Fixes "mkdir /homeless-shelter: permission denied" - "Error: error compiling magefiles" during build
    export HOME=$(mktemp -d)
    mage build:build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dt $out/bin vikunja
    runHook postInstall
  '';

  passthru.tests.vikunja = nixosTests.vikunja;

  meta = {
    changelog = "https://kolaente.dev/vikunja/api/src/tag/v${version}/CHANGELOG.md";
    description = "API of the Vikunja to-do list app";
    homepage = "https://vikunja.io/";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ leona ];
    mainProgram = "vikunja";
    platforms = lib.platforms.all;
  };
}
