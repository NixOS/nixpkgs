{ lib, buildGoModule, fetchFromGitea, mage, writeShellScriptBin }:

buildGoModule rec {
  pname = "vikunja-api";
  version = "0.17.1";

  src = fetchFromGitea {
    domain = "kolaente.dev";
    owner = "vikunja";
    repo = "api";
    rev = "v${version}";
    sha256 = "sha256-xqC7MaPe5cClMUTSRE3HLTEH3LH1J1bJSdH+1ZOfGo4=";
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
      in [ fakeGit mage ];

  vendorSha256 = "sha256-/vXyZznGxj5hxwqi4sttBBkEoS25DJqwoBtADCRO9Qc=";

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

  meta = {
    description = "API of the Vikunja to-do list app";
    homepage = "https://vikunja.io/";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ em0lar ];
    platforms = lib.platforms.all;
  };
}
