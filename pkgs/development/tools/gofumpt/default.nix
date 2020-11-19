{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gofumpt";
  version = "2020-10-27";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = pname;
    rev = "85d5401eb0f699d87b0d6c949dd4c0d5fb23f2e0";
    sha256 = "0n72d7p4y89kfilcdx3qb63qy6xm8dyp6q8s8954wrkm2wlhkwiy";
  };

  vendorSha256 = "1s546hp4ngzqvfx7dbd43k7b94z0mvndgdkndh4ypkkl3rpd9kkz";

  doCheck = false;

  meta = with lib; {
    description = "A stricter gofmt";
    homepage = "https://github.com/mvdan/gofumpt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
