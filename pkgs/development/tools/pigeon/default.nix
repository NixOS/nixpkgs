{ lib, buildGoPackage, fetchFromGitHub }:
buildGoPackage {
  pname = "pigeon";
  version = "20190810-f3db42a662";

  goPackagePath = "github.com/mna/pigeon";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "mna";
    repo = "pigeon";
    rev = "f3db42a662eded7550fc7cd11605d05311dfa30f";
    sha256 = "1n0zqidwbqqfslrirpbqw14ylgiry6ggcp9ll4h8rf1chqwk6dhv";
  };

  meta = {
    homepage = "https://github.com/mna/pigeon";
    description = "A PEG parser generator for Go";
    maintainers = with lib.maintainers; [ zimbatm ];
    license = with lib.licenses; [ bsd3 ];
  };
}
