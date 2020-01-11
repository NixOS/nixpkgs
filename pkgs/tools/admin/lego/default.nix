{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "lego";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "go-acme";
    repo = pname;
    rev = "v${version}";
    sha256 = "1djvwyjg30f9bj61pf3y2k2w055pj39v0sif4rjqg8cz0j382a2z";
  };

  modSha256 = "0k3p11cji3p4nzr8aia8hp01wyx1qfx84259dwbfwg1b32ln8rkc";
  subPackages = [ "cmd/lego" ];

  meta = with lib; {
    description = "Let's Encrypt client and ACME library written in Go";
    license = licenses.mit;
    homepage = "https://go-acme.github.io/lego/";
    maintainers = with maintainers; [ andrew-d ];
  };
}
