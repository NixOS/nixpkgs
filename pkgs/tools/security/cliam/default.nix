{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "cliam";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "securisec";
    repo = pname;
    rev = version;
    hash = "sha256-TEpAY1yY5AFTg5yUZMvTFdZiQ7yBi0rjYgCCksiMfDU=";
  };

  vendorSha256 = "sha256-VCai9rxpnlpviN5W/VIRcNGvPljE2gbFnxA1OKhVElk=";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/securisec/cliam/cli/version.Version=${version}"
  ];

  postBuild = ''
    # should be called cliam
    mv $GOPATH/bin/{cli,cliam}
  '';

  postInstall = ''
    installShellCompletion --cmd cliam \
      --bash <($out/bin/cliam completion bash) \
      --fish <($out/bin/cliam completion fish) \
      --zsh <($out/bin/cliam completion zsh)
  '';

  meta = with lib; {
    description = "Cloud agnostic IAM permissions enumerator";
    homepage = "https://github.com/securisec/cliam";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
