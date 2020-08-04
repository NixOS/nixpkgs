{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gofumpt";
  version = "2019-11-11";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = pname;
    rev = "eb442649d62000da5d11671f3beb1afa1b746fd7";
    sha256 = "1cw9mmavxz8gxzzwsllvf5lwb2wwi19jbc7hcwxsi4ywp7a84gh0";
  };

  vendorSha256 = "14a3p163xy861xb6x160wy15hzjc75n36jdyzaxl877i17shba8z";

  meta = with lib; {
    description = "A stricter gofmt";
    homepage = "https://github.com/mvdan/gofumpt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
