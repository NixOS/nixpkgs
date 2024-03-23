{ lib, stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "steampipe";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "turbot";
    repo = "steampipe";
    rev = "v${version}";
    hash = "sha256-Qmb4dBLtztrhnm8fKEkaxX2tJAXsQ+/C8cweQbRc7uk=";
  };

  vendorHash = "sha256-2p/D/sycx78BXBe+WHeYP4hLz1aX33cCRQ/AbwKkidM=";
  proxyVendor = true;

  patchPhase = ''
    runHook prePatch
    # Patch test that relies on looking up homedir in user struct to prefer ~
    substituteInPlace pkg/steampipeconfig/shared_test.go \
      --replace 'filehelpers "github.com/turbot/go-kit/files"' "" \
      --replace 'filepaths.SteampipeDir, _ = filehelpers.Tildefy("~/.steampipe")' 'filepaths.SteampipeDir = "~/.steampipe"';
    runHook postPatch
  '';

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" "-w" ];

  # panic: could not create backups directory: mkdir /var/empty/.steampipe: operation not permitted
  doCheck = !stdenv.isDarwin;

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
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ hardselius ];
    changelog = "https://github.com/turbot/steampipe/blob/v${version}/CHANGELOG.md";
  };
}
