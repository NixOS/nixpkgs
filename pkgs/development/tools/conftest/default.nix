{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "conftest";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "open-policy-agent";
    repo = "conftest";
    rev = "v${version}";
    sha256 = "1mjfb39h6z8dbrqxlvrvnzid7la6wj709kx7dva4126i84cmpyf1";
  };

  vendorSha256 = "08c4brwvjp9f7cpzywxns6dkhl3jzq9ckyvphm2jnm2kxmkawbbn";

  doCheck = false;

  buildFlagsArray = ''
    -ldflags=
        -X main.version=${version}
  '';

  meta = with lib; {
    description = "Write tests against structured configuration data";
    inherit (src.meta) homepage;
    license = licenses.asl20;
    maintainers = with maintainers; [ yurrriq ];
  };
}
