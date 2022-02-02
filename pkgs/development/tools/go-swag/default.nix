{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "go-swag";
  version = "1.6.7";

  src = fetchFromGitHub {
    owner = "swaggo";
    repo = "swag";
    rev = "v${version}";
    sha256 = "17pmcfkcmgjvs4drs0fyhp2m39gw83s0ck3rdzdkgdhrbhva9ksx";
  };

  vendorSha256 = "1i2n2sz2hc89nf2fqfq3swldz0xwrnms4j9q0lrss5gm3bk49q7f";

  subPackages = [ "cmd/swag" ];

  meta = with lib; {
    description = "Automatically generate RESTful API documentation with Swagger 2.0 for Go";
    homepage = "https://github.com/swaggo/swag";
    license = licenses.mit;
    maintainers = with maintainers; [ stephenwithph ];
  };
}
