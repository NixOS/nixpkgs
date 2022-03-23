{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pg_flame";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "mgartner";
    repo = pname;
    rev = "v${version}";
    sha256 = "1a03vxqnga83mhjp7pkl0klhkyfaby7ncbwm45xbl8c7s6zwhnw2";
  };

  vendorSha256 = "1rkx20winh66y2m7i7q13jpr83044i2d1pfd5p5l5kkpsix5mra5";

  meta = with lib; {
    description = "Flamegraph generator for Postgres EXPLAIN ANALYZE output";
    homepage = "https://github.com/mgartner/pg_flame";
    license = licenses.asl20;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
