{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "threatest";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "DataDog";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-FDcCAKexFpqViSQngfOhkjTr0czHIRtZL3v2psfTuYI=";
  };

  proxyVendor = true;
  vendorHash = "sha256-UQ3GPSv7P4+oMvcu4eFlosnw0TQxG33ptlMTQA/5Lkw=";

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
