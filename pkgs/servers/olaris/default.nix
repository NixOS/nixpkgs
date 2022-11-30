{ buildGoModule, fetchFromGitLab, fetchzip, installShellFiles, lib }:

buildGoModule rec {
  pname = "olaris-server";
  version = "0.4.0";

  src = fetchFromGitLab {
  owner = "olaris";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-iworyQqyTabTI0NpZHTdUBGZSCaiC5Dhr69mRtsHLOs=";
  };

  preBuild = let
    olaris-react = fetchzip {
      url = "https://gitlab.com/api/v4/projects/olaris%2Folaris-react/jobs/artifacts/v${version}/download?job=build";
      extension = "zip";
      hash = "sha256-MkxBf/mGvtiOu0e79bMpd9Z/D0eOxhzPE+bKic//viM=";
    };
  in ''
    # cannot build olaris-react https://github.com/NixOS/nixpkgs/issues/203708
    cp -r ${olaris-react} react/build
    make generate
  '';

  ldflags = [
    "-s"
    "-w"
    "-X gitlab.com/olaris/olaris-server/helpers.Version=${version}"
  ];

  vendorHash = "sha256-xWywDgw0LzJhPtVK0aGgT0TTanejJ39ZmGc50A3d68U=";

  nativeBuildInputs = [ installShellFiles ];

  # integration tests require network access
  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd olaris-server \
      --bash <($out/bin/olaris-server completion bash) \
      --fish <($out/bin/olaris-server completion fish) \
      --zsh <($out/bin/olaris-server completion zsh)
  '';

  meta = with lib; {
    description = "A media manager and transcoding server.";
    homepage = "https://gitlab.com/olaris/olaris-server";
    changelog = "https://gitlab.com/olaris/olaris-server/-/releases/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ urandom ];
  };
}
