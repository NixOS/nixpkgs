{ lib
, buildGoModule
, fetchFromGitHub
, substituteAll
, installShellFiles
, testers
, org-stats
}:

buildGoModule rec {
  pname = "org-stats";
  version = "1.11.2";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "org-stats";
    rev = "v${version}";
    hash = "sha256-b0Cfs4EqQOft/HNAoJvRriCMzNiOgYagBLiPYgsDgJM=";
  };

  vendorHash = "sha256-LKpnEXVfxBR3cebv46QontDVeA64MJe0vNiKSnTjLtQ=";

  patches = [
    # patch in version information
    # since `debug.ReadBuildInfo` does not work with `go build
    (substituteAll {
      src = ./version.patch;
      inherit version;
    })
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [ "-s" "-w" ];

  postInstall = ''
    $out/bin/org-stats man > org-stats.1
    installManPage org-stats.1

    installShellCompletion --cmd org-stats \
      --bash <($out/bin/org-stats completion bash) \
      --fish <($out/bin/org-stats completion fish) \
      --zsh <($out/bin/org-stats completion zsh)
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = org-stats;
      command = "org-stats version";
    };
  };

  meta = with lib; {
    description = "Get the contributor stats summary from all repos of any given organization";
    homepage = "https://github.com/caarlos0/org-stats";
    changelog = "https://github.com/caarlos0/org-stats/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "org-stats";
  };
}
