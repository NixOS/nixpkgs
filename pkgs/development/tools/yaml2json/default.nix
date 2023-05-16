<<<<<<< HEAD
{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "yaml2json";
  version = "1.3.2";
=======
{ lib, buildGoPackage, fetchFromGitHub }:


buildGoPackage rec {
  pname = "yaml2json";
  version = "1.3";
  goPackagePath = "github.com/bronze1man/yaml2json";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "bronze1man";
    repo = "yaml2json";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-yVA5eV+/TxWN3wzsHy5++IGMAopkCz+PBfjSD+TNKc8=";
  };

  vendorHash = "sha256-g+yaVIx4jxpAQ/+WrGKxhVeliYx7nLQe/zsGpxV4Fn4=";

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" ];

=======
    sha256 = "0bhjzl4qibiyvn56wcsm85f3vwnlzf4gywy2gq9mrnbrl629amq1";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    homepage = "https://github.com/bronze1man/yaml2json";
    description = "Convert yaml to json";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.adisbladis ];
  };
}
