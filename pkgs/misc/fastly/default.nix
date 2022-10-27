{ lib, fetchFromGitHub, installShellFiles, buildGoModule, go }:

buildGoModule rec {
  pname = "fastly";
  version = "3.2.4";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-eIqdDBU4NWNMyRs+h30ufg4QwEEGid+wCjATZYXDGm8=";
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

  subPackages = [ "cmd/fastly" ];

  vendorSha256 = "sha256-glztVmAAdkEccJEFIHGWjNzz/+MjExSX18GDX66sdxA=";

  nativeBuildInputs = [ installShellFiles ];

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
  preBuild = ''
    ldflags+=" -X github.com/fastly/cli/pkg/revision.GitCommit=$(cat COMMIT)"
  '';

  postInstall = ''
    export HOME="$(mktemp -d)"
    installShellCompletion --cmd fastly \
      --bash <($out/bin/fastly --completion-script-bash) \
      --zsh <($out/bin/fastly --completion-script-zsh)
  '';

  meta = with lib; {
    description = "Command line tool for interacting with the Fastly API";
    license = licenses.asl20;
    homepage = "https://github.com/fastly/cli";
    maintainers = with maintainers; [ ereslibre shyim ];
  };
}
