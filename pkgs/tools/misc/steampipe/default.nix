{ stdenv, lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "steampipe";
  version = "0.18.6";

  src = fetchFromGitHub {
    owner = "turbot";
    repo = "steampipe";
    rev = "v${version}";
    sha256 = "sha256-H/R+NXFaZ23vWN16/Ft5oP+Xvc97VY98cQth5+LtqnA=";
  };

  vendorHash = "sha256-W30f7QYgm+QyLDJICpjMn7mtUIziTR1igThEbv+Aa7M=";
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
    changelog = "https://github.com/turbot/steampipe/blob/v${version}/CHANGELOG.md";
  };
}
