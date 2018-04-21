{ stdenv, buildGoPackage, fetchFromGitHub }:

let
  rev      = "966f3c5f45ba18b2225c5b06918e41f56e223e73";
  revCount = "240";
  sha256   = "1m70a5rpycrfwrrc83745mamgpg54pc0n75qpzr9jbvicbp8g66p";
in
buildGoPackage rec {
  name = "wal-g-${version}";
  version = "0.1.8pre${revCount}_${builtins.substring 0 9 rev}";

  src = fetchFromGitHub {
    owner = "wal-g";
    repo  = "wal-g";
    inherit rev sha256;
  };

  goPackagePath = "github.com/wal-g/wal-g";
  meta = {
    homepage = https://github.com/wal-g/wal-g;
    license = stdenv.lib.licenses.asl20;
    description = "An archival restoration tool for Postgres";
    maintainers = [ stdenv.lib.maintainers.ocharles ];
  };
}
