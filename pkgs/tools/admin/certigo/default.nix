{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "certigo";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "square";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+j1NeQJPDwQxXVYnHNmL49Li2IMH+9ehS0HSM3kqyxU=";
  };

  vendorSha256 = "sha256-G9YpMF4qyL8eJPnai81ihVTDK9E4meKxdpk+rjISnIM=";

  meta = with lib; {
    description = "A utility to examine and validate certificates in a variety of formats";
    homepage = "https://github.com/square/certigo";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
