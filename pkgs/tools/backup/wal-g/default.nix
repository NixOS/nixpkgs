{ stdenv, buildGoPackage, fetchurl }:
buildGoPackage rec {
  name = "wal-g-${version}";
  version = "0.1.2";
  src = fetchurl {
    url = https://github.com/wal-g/wal-g/archive/v0.1.2.tar.gz;
    sha256 = "0zkjs72gq7sc9cqqzxr6ms1ibk8466zpwmrziq9p4jv9r4iq3bfb";
  };
  goPackagePath = "github.com/wal-g/wal-g";
  meta = {
    homepage = https://github.com/wal-g/wal-g;
    license = stdenv.lib.licenses.asl20;
    description = "An archival restoration tool for Postgres";
    maintainers = [ stdenv.lib.maintainers.ocharles ];
  };
}
