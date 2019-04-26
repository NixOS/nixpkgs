{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "timescaledb-tune";
  version = "0.5.0";

  goPackagePath = "github.com/timescale/timescaledb-tune";

  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "timescale";
    repo = name;
    rev = version;
    sha256 = "1fs7ggpdik3qjvjmair1svni2sw9wz54716m2iwngv8x4s9b15nn";
  };

  meta = with stdenv.lib; {
    description = "A tool for tuning your TimescaleDB for better performance";
    homepage = https://github.com/timescale/timescaledb-tune;
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ];
  };
}
