{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "statik";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "rakyll";
    repo = "statik";
    rev = "v${version}";
    sha256 = "ahsNiac/3I2+PUqc90E73Brb99M68ewh9nWXoupfE3g=";
  };

  vendorSha256 = "pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";

  # Avoid building example
  subPackages = [ "." "fs" ];
  # Tests are checking that the files embeded are preserving
  # their meta data like dates etc, but it assumes to be in 2048
  # which is not the case once entered the nix store
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/rakyll/statik";
    description = "Embed files into a Go executable ";
    license = licenses.asl20;
    maintainers = with maintainers; [ Madouura ];
  };
}
