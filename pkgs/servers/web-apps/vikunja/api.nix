{ lib, buildGoModule, fetchFromGitea, mage, writeShellScriptBin, nixosTests }:

buildGoModule rec {
  pname = "vikunja-api";
  version = "0.19.0";

  src = fetchFromGitea {
    domain = "kolaente.dev";
    owner = "vikunja";
    repo = "api";
    rev = "v${version}";
    sha256 = "sha256-1BxkQFiAqH+n8yzQn0+5cd/Z6oEBbGuK1pu1qt8CUbk=";
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

  vendorSha256 = "fzk22B7KpXfGS+8GF6J3ydmFyvP7oelRuiF+IveYdg4=";

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
    description = "API of the Vikunja to-do list app";
    homepage = "https://vikunja.io/";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ leona ];
    mainProgram = "vikunja";
    platforms = lib.platforms.all;
  };
}
