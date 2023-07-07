{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, asciidoc
, databasePath ? "/etc/secureboot"
}:

buildGoModule rec {
  pname = "sbctl";
  version = "0.11";

  src = fetchFromGitHub {
    owner = "Foxboron";
    repo = pname;
    rev = version;
    hash = "sha256-kApPb8X1JCP1XfyVFcoCDd+yrytTKSkNWRHKDA3mGaQ=";
  };

  vendorHash = "sha256-WbPYTETTOzqWH+q6fzyDgm0wMScbLWlksLxkDjopF4E=";

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
