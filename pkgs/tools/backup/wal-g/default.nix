{ lib, buildGoModule, fetchFromGitHub, brotli, libsodium, installShellFiles }:

buildGoModule rec {
  pname = "wal-g";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "wal-g";
    repo = "wal-g";
    rev = "v${version}";
    sha256 = "sha256-k+GaOb+o5b+Rmggk+Wq3NscDS+fIvyK0e/EhX6UMlqM=";
  };

  vendorHash = "sha256-ZsVqR02D4YmZP/tVz2UWpXa6fM7HU7Hi2CSnvuVx9UU=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ brotli libsodium ];

  subPackages = [ "main/pg" ];

  tags = [ "brotli" "libsodium" ];

  ldflags = [ "-s" "-w" "-X github.com/wal-g/wal-g/cmd/pg.walgVersion=${version}" "-X github.com/wal-g/wal-g/cmd/pg.gitRevision=${src.rev}" ];

  postInstall = ''
    mv $out/bin/pg $out/bin/wal-g
    installShellCompletion --cmd wal-g \
      --bash <($out/bin/wal-g completion bash) \
      --zsh <($out/bin/wal-g completion zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/wal-g/wal-g";
    license = licenses.asl20;
    description = "An archival restoration tool for PostgreSQL";
    mainProgram = "wal-g";
    maintainers = with maintainers; [ ];
  };
}
