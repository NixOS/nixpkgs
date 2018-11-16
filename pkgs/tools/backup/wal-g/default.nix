{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "wal-g-${version}";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner  = "wal-g";
    repo   = "wal-g";
    rev    = "v${version}";
    sha256 = "06k71xz96jpg6966xj48a8j07v0vk37b5v2k1bnqrbin4sma3s0c";
  };

  goPackagePath = "github.com/wal-g/wal-g";
  meta = {
    inherit (src.meta) homepage;
    license = stdenv.lib.licenses.asl20;
    description = "An archival restoration tool for Postgres";
    maintainers = [ stdenv.lib.maintainers.ocharles ];
  };
}
