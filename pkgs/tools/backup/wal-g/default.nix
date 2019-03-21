{ stdenv, buildGoPackage, fetchFromGitHub, brotli }:

buildGoPackage rec {
  name = "wal-g-${version}";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner  = "wal-g";
    repo   = "wal-g";
    rev    = "v${version}";
    sha256 = "08lk7by1anxpd9v97xbf9443kk4n1w63zaar2nz86w8i3k3b4id9";
  };

  buildInputs = [ brotli ];

  doCheck = true;

  goPackagePath = "github.com/wal-g/wal-g";
  meta = {
    inherit (src.meta) homepage;
    license = stdenv.lib.licenses.asl20;
    description = "An archival restoration tool for Postgres";
    maintainers = [ stdenv.lib.maintainers.ocharles ];
  };
}
