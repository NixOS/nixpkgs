{ lib, buildGoModule, fetchFromGitHub, brotli, libsodium }:

buildGoModule rec {
  pname = "wal-g";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "wal-g";
    repo = "wal-g";
    rev = "v${version}";
    sha256 = "1hiym5id310rvw7vr8wir2vpf0p5qz71rx6v5i2gpjqml7c97cls";
  };

  vendorSha256 = "09z9x20zna1czhfpl47i98r8163a266mnr6xi17npjsfdvsjkppn";

  buildInputs = [ brotli libsodium ];

  subPackages = [ "main/pg" ];

  tags = [ "brotli" "libsodium" ];

  ldflags = [ "-s" "-w" "-X github.com/wal-g/wal-g/cmd/pg.WalgVersion=${version}" "-X github.com/wal-g/wal-g/cmd/pg.GitRevision=${src.rev}" ];

  postInstall = ''
    mv $out/bin/pg $out/bin/wal-g
  '';

  meta = with lib; {
    homepage = "https://github.com/wal-g/wal-g";
    license = licenses.asl20;
    description = "An archival restoration tool for PostgreSQL";
    maintainers = with maintainers; [ marsam ];
  };
}
