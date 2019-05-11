{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "timescaledb-tune";
  version = "0.6.0";

  goPackagePath = "github.com/timescale/timescaledb-tune";

  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "timescale";
    repo = name;
    rev = version;
    sha256 = "0hjxmjgkqm9sbjbyhs3pzkk1d9vvlcbzwl7ghsigh4h7rw3a0mpk";
  };

  meta = with stdenv.lib; {
    description = "A tool for tuning your TimescaleDB for better performance";
    homepage = https://github.com/timescale/timescaledb-tune;
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ];
  };
}
