{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "timescaledb-parallel-copy-${version}";
  version = "2018-05-14";

  owner  = "timescale";
  repo   = "timescaledb-parallel-copy";

  goPackagePath = with src; "github.com/${owner}/${repo}";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    inherit owner repo;
    rev    = "20d3e8f8219329f2f4b0a5aa985f280dd04d10bb";
    sha256 = "0waaccw991cnxaxjdxh9ksb94kiiyx1r7gif6pkd5k58js0kfvdn";
  };

  meta = with stdenv.lib; {
    description = "Bulk, parallel insert of CSV records into PostgreSQL";
    homepage    = http://github.com/timescale/timescaledb-parallel-copy;
    license     = licenses.asl20;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
