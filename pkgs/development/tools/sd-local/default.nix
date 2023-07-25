{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "sd-local";
  version = "1.0.46";

  src = fetchFromGitHub {
    owner = "screwdriver-cd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+Z12atz6fSM5FJFOqUhjalxkP/1Kkm3xWgwUVlB9JvM=";
  };

  vendorSha256 = "sha256-sgCUho8KFt0iFEuupQdMV6IZTVCsTXsNqv2ab5jp0mI=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "screwdriver.cd local mode";
    homepage = "https://github.com/screwdriver-cd/sd-local";
    license = licenses.bsd3;
    maintainers = with maintainers; [ midchildan ];
  };
}
