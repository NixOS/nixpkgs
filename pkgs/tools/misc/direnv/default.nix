{ lib, stdenv, fetchFromGitHub, buildGoModule, bash, fish, zsh }:

buildGoModule rec {
  pname = "direnv";
  version = "2.32.2";

  src = fetchFromGitHub {
    owner = "direnv";
    repo = "direnv";
    rev = "v${version}";
    sha256 = "sha256-Ql/Q9SoCNy2JKt/32RIMx08rbGvrthdgTpFIFx4m1p4=";
  };

  vendorSha256 = "sha256-eQaQ77pOYC8q+IA26ArEhHQ0DCU093TbzaYhdV3UydE=";

  # we have no bash at the moment for windows
  BASH_PATH =
    lib.optionalString (!stdenv.hostPlatform.isWindows)
    "${bash}/bin/bash";

  # replace the build phase to use the GNUMakefile instead
  buildPhase = ''
    make BASH_PATH=$BASH_PATH
  '';

  installPhase = ''
    make install PREFIX=$out
  '';

  nativeCheckInputs = [ fish zsh ];

  checkPhase = ''
    export HOME=$(mktemp -d)
    make test-go test-bash test-fish test-zsh
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
  };
}
