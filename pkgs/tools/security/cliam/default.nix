{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "cliam";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "securisec";
    repo = pname;
    rev = version;
    hash = "sha256-bq7u6pknokyY4WwO1qMYPuY86UZlDgeYEa1AJpk8d+4=";
  };

  vendorSha256 = "sha256-aGBA97EvIUv9myqcrtltiVxh1/0VtrQy2j9GU6r197g=";

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
