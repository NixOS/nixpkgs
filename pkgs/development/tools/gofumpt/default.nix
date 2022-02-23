{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gofumpt";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-S6IF/MtNCkhPHHdaQJyT78j2z4xdf4z/xLfXDmCWR2Y=";
  };

  vendorSha256 = "sha256-LhiCxpjySEezhcgICfgD+mABd1QXyZn3uI1Fj+eWiyo=";

  doCheck = false;

  meta = with lib; {
    description = "A stricter gofmt";
    homepage = "https://github.com/mvdan/gofumpt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
