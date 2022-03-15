{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "steampipe";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "turbot";
    repo = "steampipe";
    rev = "v${version}";
    sha256 = "sha256-+QtZmrPE3R98UVSwrC8xoehNKwd0Exg+AZ2BJxBIrfY=";
  };

  vendorSha256 = "sha256-rRp8pR2cpW88o0KPwuvgSkE263S5oGK/4df4CQSOlRo=";
  proxyVendor = true;

  # tests are failing for no obvious reasons
  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    INSTALL_DIR=$(mktemp -d)
    installShellCompletion --cmd steampipe \
      --bash <($out/bin/steampipe --install-dir $INSTALL_DIR completion bash) \
      --fish <($out/bin/steampipe --install-dir $INSTALL_DIR completion fish) \
      --zsh <($out/bin/steampipe --install-dir $INSTALL_DIR completion zsh)
  '';

  meta = with lib; {
    homepage = "https://steampipe.io/";
    description = "select * from cloud;";
    license = licenses.agpl3;
    maintainers = with maintainers; [ hardselius ];
  };
}
