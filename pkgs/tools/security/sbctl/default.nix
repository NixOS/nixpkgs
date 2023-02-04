{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, asciidoc
, databasePath ? "/etc/secureboot"
}:

buildGoModule rec {
  pname = "sbctl";
  version = "0.10";

  src = fetchFromGitHub {
    owner = "Foxboron";
    repo = pname;
    rev = version;
    hash = "sha256-rjqfWOJRG+9GbNNeRafkNx7Khm/vtGeMlfKkz0qFXJY=";
  };

  vendorSha256 = "sha256-3wT/pWKIdEpkLUpOmpKhLA9AyO36LqZBAwamzOUGhFY=";

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
