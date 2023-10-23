{ lib, stdenv, fetchFromGitHub, buildGoModule, bash, fish, zsh }:

buildGoModule rec {
  pname = "direnv";
  version = "2.32.3";

  src = fetchFromGitHub {
    owner = "direnv";
    repo = "direnv";
    rev = "v${version}";
    sha256 = "sha256-TDr2eL7Jft1r2IMm6CToVCEhiNo+Rj1H/Skoe+wx1MM=";
  };

  vendorHash = "sha256-eQaQ77pOYC8q+IA26ArEhHQ0DCU093TbzaYhdV3UydE=";

  # we have no bash at the moment for windows
  BASH_PATH =
    lib.optionalString (!stdenv.hostPlatform.isWindows)
    "${bash}/bin/bash";

  # replace the build phase to use the GNUMakefile instead
  buildPhase = ''
    runHook preBuild

    make BASH_PATH=$BASH_PATH

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    make install PREFIX=$out

    runHook postInstall
  '';

  nativeCheckInputs = [ fish zsh ];

  checkPhase = ''
    runHook preCheck

    export HOME=$(mktemp -d)
    make test-go test-bash test-fish test-zsh

    runHook postCheck
  '';

  meta = with lib; {
    description = "A shell extension that manages your environment";
    longDescription = ''
      Once hooked into your shell direnv is looking for an .envrc file in your
      current directory before every prompt.

      If found it will load the exported environment variables from that bash
      script into your current environment, and unload them if the .envrc is
      not reachable from the current path anymore.

      In short, this little tool allows you to have project-specific
      environment variables.
    '';
    homepage = "https://direnv.net";
    license = licenses.mit;
    maintainers = teams.numtide.members;
    mainProgram = "direnv";
  };
}
