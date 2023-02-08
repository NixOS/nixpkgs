{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "katana";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Ax99pmoxlyUGLN2OdIItTNTnO/fDquvNadNnNG6ElEk=";
  };

  vendorHash = "sha256-IJcMIJF2A5DfyBdcIXTbeX72Q/4SAVZ0U3UIQ2H0fEc=";

  CGO_ENABLED = 0;

  subPackages = [ "cmd/katana" ];

  meta = with lib; {
    description = "A next-generation crawling and spidering framework";
    homepage = "https://github.com/projectdiscovery/katana";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
