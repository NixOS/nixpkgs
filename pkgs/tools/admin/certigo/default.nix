{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "certigo";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "square";
    repo = pname;
    rev = "v${version}";
    sha256 = "0siwbxxzknmbsjy23d0lvh591ngabqhr2g8mip0siwa7c1y7ivv4";
  };

  vendorSha256 = "1l6ajfl04rfbssvijgd5jrppmqc5svfrswdx01x007lr8rvdfd94";

  doCheck = false;

  meta = with lib; {
    description = "A utility to examine and validate certificates in a variety of formats";
    homepage = "https://github.com/square/certigo";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
