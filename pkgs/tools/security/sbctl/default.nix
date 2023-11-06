{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, asciidoc
, databasePath ? "/etc/secureboot"
}:

buildGoModule rec {
  pname = "sbctl";
  version = "0.12";

  src = fetchFromGitHub {
    owner = "Foxboron";
    repo = pname;
    rev = version;
    hash = "sha256-1dA+a8GS4teaLmclatJNKt+OjhabLO4j/+p4Q95yG/s=";
  };

  vendorHash = "sha256-kVXzHTONPCE1UeAnUiULjubJeZFD0DAxIk+w8/Dqs6c=";

  ldflags = [ "-s" "-w" "-X github.com/foxboron/sbctl.DatabasePath=${databasePath}" ];

  nativeBuildInputs = [ installShellFiles asciidoc ];

  postBuild = ''
    make docs/sbctl.8
  '';

  postInstall = ''
    installManPage docs/sbctl.8

    installShellCompletion --cmd sbctl \
    --bash <($out/bin/sbctl completion bash) \
    --fish <($out/bin/sbctl completion fish) \
    --zsh <($out/bin/sbctl completion zsh)
  '';

  meta = with lib; {
    description = "Secure Boot key manager";
    homepage = "https://github.com/Foxboron/sbctl";
    license = licenses.mit;
    maintainers = with maintainers; [ raitobezarius ];
    # go-uefi do not support darwin at the moment:
    # see upstream on https://github.com/Foxboron/go-uefi/issues/13
    platforms = platforms.linux;
  };
}
