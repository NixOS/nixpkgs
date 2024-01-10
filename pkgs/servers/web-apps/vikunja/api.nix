{ lib, buildGoModule, fetchFromGitHub, mage, writeShellScriptBin, nixosTests }:

buildGoModule rec {
  pname = "vikunja-api";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "go-vikunja";
    repo = "api";
    rev = "v${version}";
    hash = "sha256-hqyopIV/cLLC8An+ELN0a/cFAq6BoCZZjBRviaJ5ygI=";
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

  vendorHash = "sha256-+V6a6h5pg8FU87pA4JxZo07HGBXIgCv4FjmtjIpQUP4=";

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
