{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "threatest";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "DataDog";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-pCSSAEeVxi3/yK7B2g9ZZRU5TjdNd8qp+52Yc1HmxT8=";
  };

  proxyVendor = true;
  vendorHash = "sha256-nHA+UJP6gYWdbTKFcxw1gI6X2ueTUIsHVBIlaprPwsQ=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd threatest \
      --bash <($out/bin/threatest completion bash) \
      --fish <($out/bin/threatest completion fish) \
      --zsh <($out/bin/threatest completion zsh)
  '';

  meta = with lib; {
    description = "Framework for end-to-end testing threat detection rules";
    homepage = "https://github.com/DataDog/threatest";
    changelog = "https://github.com/DataDog/threatest/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
