{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "remarshal-${rev}";
  rev = "0.3.0";
  goPackagePath = "github.com/dbohdan/remarshal";

  src = fetchFromGitHub {
    rev = "v${rev}";
    owner  = "dbohdan";
    repo   = "remarshal";
    sha256 = "0lhsqca3lq3xvdwsmrngv4p6b7k2lkbfnxnk5qj6jdd5y7f4b496";
  };

  goDeps = ./deps.json;

  meta = with lib; {
    description = "Convert between TOML, YAML and JSON";
    license = licenses.mit;
    homepage = https://github.com/dbohdan/remarshal;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
