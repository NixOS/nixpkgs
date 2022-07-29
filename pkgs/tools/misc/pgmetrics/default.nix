{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pgmetrics";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "rapidloop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Cvx3Lc4FH6RX9UrjX7L3FSt+CcAWieBRTFT1CsLkdFg=";
  };

  vendorSha256 = "sha256-aE/TZ0QlGYvuMVZDntXmYkUKos5NTI/ncRPp9A4CScY=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    homepage = "https://pgmetrics.io/";
    description = "Collect and display information and stats from a running PostgreSQL server";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
