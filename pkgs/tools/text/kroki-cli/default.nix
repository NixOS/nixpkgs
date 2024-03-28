{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "kroki-cli";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "yuzutech";
    repo = "kroki-cli";
    rev = "v${version}";
    hash = "sha256-nvmfuG+i1vw2SZIb1g5mS48uZKnjUgKSN/hip5nY2ig=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse --short HEAD > $out/COMMIT
      # in format of 0000-00-00T00:00:00Z
      date -u -d "@$(git log -1 --pretty=%ct)" "+%Y-%m-%dT%H:%M:%SZ" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = "sha256-HqiNdNpNuFBfwmp2s0gsa2YVf3o0O2ILMQWfKf1Mfaw=";

  nativeBuildInputs = [ installShellFiles ];

  # ldflags based on metadata from git and source
  preBuild = ''
    ldflags+=" -X main.commit=$(cat COMMIT)"
    ldflags+=" -X main.date=$(cat SOURCE_DATE_EPOCH)"
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd kroki \
      --bash <($out/bin/kroki completion bash) \
      --fish <($out/bin/kroki completion fish) \
      --zsh <($out/bin/kroki completion zsh)
  '';

  meta = with lib; {
    description = "A Kroki CLI";
    homepage = "https://github.com/yuzutech/kroki-cli";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ blaggacao ];
  };
}
