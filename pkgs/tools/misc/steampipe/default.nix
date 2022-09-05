{ stdenv, lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "steampipe";
  version = "0.15.3";

  src = fetchFromGitHub {
    owner = "turbot";
    repo = "steampipe";
    rev = "v${version}";
    sha256 = "sha256-7TIEdT+s6Am2hPiMPKH+YioNfsCmLVZg6BQiO94Xiu0=";
  };

  vendorSha256 = "sha256-x57IvMKSE2F5bGTC8ao+wLJmYlz8nMh4SoMhtGlwQyE=";
  proxyVendor = true;

  patchPhase = ''
    # Patch test that relies on looking up homedir in user struct to prefer ~
    substituteInPlace pkg/steampipeconfig/shared_test.go \
      --replace '"github.com/turbot/go-kit/helpers"' "" \
      --replace 'filepaths.SteampipeDir, _ = helpers.Tildefy("~/.steampipe")' 'filepaths.SteampipeDir = "~/.steampipe"';
  '';

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" "-w" ];

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
