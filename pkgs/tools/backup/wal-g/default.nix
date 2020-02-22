{ stdenv, buildGoPackage, fetchFromGitHub, brotli }:

buildGoPackage rec {
  pname = "wal-g";
  version = "0.2.14";

  src = fetchFromGitHub {
    owner  = "wal-g";
    repo   = "wal-g";
    rev    = "v${version}";
    sha256 = "0rrn9kzcg3nw9qvzy58m4qacghv0pj7iyjh4yspc71n5nkamkfgm";
  };

  buildInputs = [ brotli ];

  doCheck = true;

  goPackagePath = "github.com/wal-g/wal-g";

  goDeps = ./deps.nix;

  subPackages = [ "main/pg" ];

  buildFlagsArray = [ "-ldflags=-s -w -X ${goPackagePath}/cmd/pg.WalgVersion=${version} -X ${goPackagePath}/cmd/pg.GitRevision=${src.rev}" ];

  postInstall = ''
    mv $bin/bin/pg $bin/bin/wal-g
  '';

  meta = {
    homepage = "https://github.com/wal-g/wal-g";
    license = stdenv.lib.licenses.asl20;
    description = "An archival restoration tool for PostgreSQL";
    maintainers = [ stdenv.lib.maintainers.ocharles ];
  };
}
