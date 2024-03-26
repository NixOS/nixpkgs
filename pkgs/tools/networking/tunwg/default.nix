{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tunwg";
  version = "24.01.15+9f04d73";

  src = fetchFromGitHub {
    owner = "ntnj";
    repo = "tunwg";
    rev = "v${version}";
    hash = "sha256-M7iMl80uxw0hKg4sK8Tv6U5+nMOK8eTfb9SGn+U2+8E=";
  };

  vendorHash = "sha256-VlH41hOWC5QBCYZxiKCUZRmw2vHRbbPyzToRMU6kDO8=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Secure private tunnel to your local servers";
    homepage = "https://github.com/ntnj/tunwg";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "tunwg";
  };
}
