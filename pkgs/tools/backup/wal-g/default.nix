{ lib, buildGoModule, fetchFromGitHub, brotli }:

buildGoModule rec {
  pname = "wal-g";
  version = "0.2.18";

  src = fetchFromGitHub {
    owner = "wal-g";
    repo = "wal-g";
    rev = "v${version}";
    sha256 = "1clsh42sgfrzyg3vr215wrpi93cb8y8ky3cb1v2l6cs4psh3py1q";
  };

  vendorSha256 = "1ax8niw4zfwvh5ikxnkbsjc9fdz1lziqlwig9nwrhzfp45ysbakh";

  buildInputs = [ brotli ];

  subPackages = [ "main/pg" ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/wal-g/wal-g/cmd/pg.WalgVersion=${version} -X github.com/wal-g/wal-g/cmd/pg.GitRevision=${src.rev}" ];

  postInstall = ''
    mv $out/bin/pg $out/bin/wal-g
  '';

  meta = with lib; {
    homepage = "https://github.com/wal-g/wal-g";
    license = licenses.asl20;
    description = "An archival restoration tool for PostgreSQL";
    maintainers = with maintainers; [ ocharles marsam ];
  };
}
