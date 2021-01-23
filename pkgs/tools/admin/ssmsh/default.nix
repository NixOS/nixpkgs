{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ssmsh";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "bwhaley";
    repo = pname;
    rev = "v${version}";
    sha256 = "0mgx4q21f6rxih79l0hwgzwafxviz5a33dpvc5k0z172sfw0dmj1";
  };

  vendorSha256 = "147f02bl3sf073dy2ximbavdcbphdn7djgisla1cyyy4ng6dhf7f";

  doCheck = true;

  buildFlagsArray = [ "-ldflags=-w -s -X main.Version=${version}" ];

  meta = with lib; {
    homepage = "https://github.com/bwhaley/ssmsh";
    description = "An interactive shell for AWS Parameter Store";
    license = licenses.mit;
    maintainers = with maintainers; [ dbirks ];
  };
}
