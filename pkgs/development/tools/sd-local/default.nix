{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "sd-local";
  version = "1.0.27";

  src = fetchFromGitHub {
    owner = "screwdriver-cd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-aJxSLOUmTuPzBJCnXv2d09Kdh/jPPBUmFnuq8629PWY=";
  };

  vendorSha256 = "sha256-3KNYG6RBnfFRgIoIyAe7QwAB56ZMF8bHdgt9Ghtod20=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "screwdriver.cd local mode";
    homepage = "https://github.com/screwdriver-cd/sd-local";
    license = licenses.bsd3;
    maintainers = with maintainers; [ midchildan ];
  };
}
