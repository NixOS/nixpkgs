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

  modSha256 = "0j7qpvji546z0cfjijdd66l0vsl0jmny6i1n9fsjqjgjpwg26naq";

  meta = with lib; {
    description = "Flamegraph generator for Postgres EXPLAIN ANALYZE output";
    homepage = "https://github.com/mgartner/pg_flame";
    license = licenses.asl20;
    maintainers = with maintainers; [ filalex77 ];
  };
}
