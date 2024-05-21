{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "go-symbols";
  version = "0.1.1";

  goPackagePath = "github.com/acroca/go-symbols";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "acroca";
    repo = "go-symbols";
    rev = "v${version}";
    sha256 = "0yyzw6clndb2r5j9isyd727njs98zzp057v314vfvknsm8g7hqrz";
  };

  meta = {
    description = "A utility for extracting a JSON representation of the package symbols from a go source tree";
    mainProgram = "go-symbols";
    homepage = "https://github.com/acroca/go-symbols";
    maintainers = with lib.maintainers; [ vdemeester ];
    license = lib.licenses.mit;
  };
}
