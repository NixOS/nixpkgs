{ lib, buildGoModule, fetchFromGitHub, brotli, libsodium, installShellFiles }:

buildGoModule rec {
  pname = "wal-g";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "wal-g";
    repo = "wal-g";
    rev = "v${version}";
    sha256 = "sha256-xltKchk7RtP5tkoUhnJqVb17WW6qW/lSFdHivCbW5zY=";
  };

  vendorSha256 = "sha256-w9AVcld8Gd1kYE2PkN8RVZ+/xlOZChKoWZFKvqhJuWI=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ brotli libsodium ];

  subPackages = [ "main/pg" ];

  tags = [ "brotli" "libsodium" ];

  ldflags = [ "-s" "-w" "-X github.com/wal-g/wal-g/cmd/pg.WalgVersion=${version}" "-X github.com/wal-g/wal-g/cmd/pg.GitRevision=${src.rev}" ];

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
    maintainers = with maintainers; [ marsam ];
  };
}
