{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "infra";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "infrahq";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uz4wimhOfeHSL949m+biIhjfDwwEGnTiJWaz/r3Rsko=";
  };

  vendorHash = "sha256-qbmaebQcD3cN+tbmzzJbry0AXz2LZFMoqbcBwGGrRo4=";

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Infra manages access to infrastructure such as Kubernetes";
    homepage = "https://github.com/infrahq/infra";
    changelog = "https://github.com/infrahq/infra/raw/v${version}/CHANGELOG.md";
<<<<<<< HEAD
    license = licenses.elastic;
=======
    license = licenses.mit;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ peterromfeldhk ];
  };
}
