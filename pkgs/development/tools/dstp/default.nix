{ lib, buildGo117Module, fetchFromGitHub }:

buildGo117Module rec {
  pname = "dstp";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "ycd";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pxzaz2a261lsnbdbr9km1214a4jzq2wgkdfvf9g966gsa4nqfl6";
  };

  vendorSha256 = "1n1kx4zcskndikjl44vwmckr6x5cv6cacwdwfwjjsf6aqgagpld8";

  # Tests require network connection, but is not allowed by nix
  doCheck = false;

  meta = with lib; {
    description = "Run common networking tests against your site";
    homepage = "https://github.com/ycd/dstp";
    license = licenses.mit;
    maintainers = with maintainers; [ jlesquembre ];
  };
}
