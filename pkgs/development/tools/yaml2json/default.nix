{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "yaml2json";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "bronze1man";
    repo = "yaml2json";
    rev = "v${version}";
    hash = "sha256-yVA5eV+/TxWN3wzsHy5++IGMAopkCz+PBfjSD+TNKc8=";
  };

  vendorHash = "sha256-g+yaVIx4jxpAQ/+WrGKxhVeliYx7nLQe/zsGpxV4Fn4=";

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/bronze1man/yaml2json";
    description = "Convert yaml to json";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.adisbladis ];
  };
}
