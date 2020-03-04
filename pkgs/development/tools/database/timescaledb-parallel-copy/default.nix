{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "timescaledb-parallel-copy";
  version = "0.2.0";

  owner  = "timescale";
  repo   = "timescaledb-parallel-copy";

  goPackagePath = with src; "github.com/${owner}/${repo}";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    inherit owner repo;
    rev    = version;
    sha256 = "1z9vf29vrxqs8imbisv681d02p4cfk3hlsrin6hhibxf1h0br9gd";
  };

  meta = with stdenv.lib; {
    description = "Bulk, parallel insert of CSV records into PostgreSQL";
    homepage    = https://github.com/timescale/timescaledb-parallel-copy;
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
