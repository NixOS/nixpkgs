{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cloudlist";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PWOC+Y+tCr5LqWJpSVoIeOquO2vMb06KW25pBEER3Ys=";
  };

  vendorHash = "sha256-FesvXH29thy6B9VXZnuvllJ+9VQR4i6q1JzrULaU82s=";

  meta = with lib; {
    description = "Tool for listing assets from multiple cloud providers";
    homepage = "https://github.com/projectdiscovery/cloudlist";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
