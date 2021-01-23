{ lib, stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "microplane";
  version = "0.0.25";

  src = fetchFromGitHub {
    owner = "Clever";
    repo = "microplane";
    rev = "v${version}";
    sha256 = "0vynkv3d70q8d079kgdmwbavyyrjssqnd223dl1rikyy7sd5sli8";
  };

  goPackagePath = "github.com/Clever/microplane";

  subPackages = ["."];

  # Regenerate deps.nix with the following steps:
  # git clone git@github.com:Clever/microplane.git
  # cd microplane
  # git checkout v<version>
  # dep2nix

  goDeps = ./deps.nix;

  buildFlagsArray = ''
    -ldflags="-s -w -X main.version=v${version}"
  '';

  postInstall = ''
    ln -s $out/bin/microplane $out/bin/mp
  '';

  meta = with lib; {
    description = "A CLI tool to make git changes across many repos";
    homepage = "https://github.com/Clever/microplane";
    license = licenses.asl20;
    maintainers = with maintainers; [ dbirks ];
  };
}
