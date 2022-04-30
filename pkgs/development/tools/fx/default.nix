{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fx";
  version = "22.0.10";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = pname;
    rev = version;
    sha256 = "sha256-BoWb27sRqcYHSLhUvjRIRIkcj90FitpbrH2R3VHsRyI=";
  };

  vendorSha256 = "sha256-ZDPRKrum2tnhscZxLzslezYs/hOOtHwAORrAWoQhXbs=";

  meta = with lib; {
    description = "Terminal JSON viewer";
    homepage = "https://github.com/antonmedv/fx";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
