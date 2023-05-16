{ lib
, fetchurl
, fetchFromGitHub
, installShellFiles
, buildGoModule
, go
, makeWrapper
, viceroy
}:

buildGoModule rec {
  pname = "fastly";
<<<<<<< HEAD
  version = "10.4.0";
=======
  version = "9.0.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "fastly";
    repo = "cli";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-NEbQ4GoZXnFes6jvqKDg4T8eDAHHEYytJ7W7qeZSCmE=";
=======
    hash = "sha256-cR0XtTzdz400p/9b8NmFxWqsSMqLf3KJRekfkWbx/Zs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    # The git commit is part of the `fastly version` original output;
    # leave that output the same in nixpkgs. Use the `.git` directory
    # to retrieve the commit SHA, and remove the directory afterwards,
    # since it is not needed after that.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse --short HEAD > $out/COMMIT
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  subPackages = [
    "cmd/fastly"
  ];

<<<<<<< HEAD
  vendorHash = "sha256-mpN4YCiuL2jrZ4r/YOUhQSOBlGGHndQyrB9GT5mTAyI=";
=======
  vendorHash = "sha256-Ch9TT5gPC8NpwuqkwHP+3HEFocWHrCZPC0T7+3VweVc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  # Flags as provided by the build automation of the project:
  #   https://github.com/fastly/cli/blob/7844f9f54d56f8326962112b5534e5c40e91bf09/.goreleaser.yml#L14-L18
  ldflags = [
    "-s"
    "-w"
    "-X github.com/fastly/cli/pkg/revision.AppVersion=v${version}"
    "-X github.com/fastly/cli/pkg/revision.Environment=release"
    "-X github.com/fastly/cli/pkg/revision.GoHostOS=${go.GOHOSTOS}"
    "-X github.com/fastly/cli/pkg/revision.GoHostArch=${go.GOHOSTARCH}"
  ];
  preBuild = let
    cliConfigToml = fetchurl {
<<<<<<< HEAD
      url = "https://web.archive.org/web/20230523192914/https://developer.fastly.com/api/internal/cli-config";
      hash = "sha256-zgZ3m69dRvuc1S7hHeLxzrM/Z/u0PKUn0XbyQOYO3es=";
=======
      url = "https://web.archive.org/web/20230412222811/https://developer.fastly.com/api/internal/cli-config";
      hash = "sha256-NACjeBGOvBL6kUBZtSx4ChZgn7V69f4K2yyDCwTZsbU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  in ''
    cp ${cliConfigToml} ./pkg/config/config.toml
    ldflags+=" -X github.com/fastly/cli/pkg/revision.GitCommit=$(cat COMMIT)"
  '';

  preFixup = ''
    wrapProgram $out/bin/fastly --prefix PATH : ${lib.makeBinPath [ viceroy ]} \
      --set FASTLY_VICEROY_USE_PATH 1
  '';

  postInstall = ''
    export HOME="$(mktemp -d)"
    installShellCompletion --cmd fastly \
      --bash <($out/bin/fastly --completion-script-bash) \
      --zsh <($out/bin/fastly --completion-script-zsh)
  '';

  meta = with lib; {
    description = "Command line tool for interacting with the Fastly API";
    homepage = "https://github.com/fastly/cli";
    changelog = "https://github.com/fastly/cli/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ereslibre shyim ];
  };
}
