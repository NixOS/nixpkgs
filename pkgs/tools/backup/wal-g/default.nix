{ lib, buildGoModule, fetchFromGitHub, brotli, libsodium }:

buildGoModule rec {
  pname = "wal-g";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "wal-g";
    repo = "wal-g";
    rev = "v${version}";
    sha256 = "0al8xg57fh3zqwgmm6lkcnpnisividhqld9jry3sqk2k45856y8j";
  };

  vendorSha256 = "0n0ymgcgkjlp0indih8h55jjj6372rdfcq717kwln6sxm4r9mb17";

  buildInputs = [ brotli libsodium ];

  subPackages = [ "main/pg" ];

  buildFlagsArray = [
    "-tags=brotli libsodium"
    "-ldflags=-s -w -X github.com/wal-g/wal-g/cmd/pg.WalgVersion=${version} -X github.com/wal-g/wal-g/cmd/pg.GitRevision=${src.rev}"
  ];

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
