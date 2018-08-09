{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "wal-g-${version}";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner  = "wal-g";
    repo   = "wal-g";
    rev    = "v${version}";
    sha256 = "0klqnrrjzzxcj3clg7vapmbga1vqsfh8mkci5r2ir1bjp0z1xfnp";
  };

  goPackagePath = "github.com/wal-g/wal-g";
  meta = {
    homepage = https://github.com/wal-g/wal-g;
    license = stdenv.lib.licenses.asl20;
    description = "An archival restoration tool for Postgres";
    maintainers = [ stdenv.lib.maintainers.ocharles ];
  };
}
