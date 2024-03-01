{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "goverview";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "j3ssie";
    repo = "goverview";
    rev = "refs/tags/v${version}";
    hash = "sha256-IgvpMuDwMK9IdPs1IRbPbpgr7xZuDX3boVT5d7Lb+3w=";
  };

  vendorHash = "sha256-i/m2s9e8PDfGmguNihynVI3Y7nAXC4weoWFXOwUVDSE=";

  ldflags = [
    "-w"
    "-s"
  ];
  nativeBuildInputs = [
    installShellFiles
  ];
  postInstall = ''
    installShellCompletion --cmd goverview \
      --bash <($out/bin/goverview completion bash) \
      --fish <($out/bin/goverview completion fish) \
      --zsh <($out/bin/goverview completion zsh)
  '';

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Tool to get an overview of the list of URLs";
    homepage = "https://github.com/j3ssie/goverview";
    changelog = "https://github.com/j3ssie/goverview/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
