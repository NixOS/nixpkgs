{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "lego";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "go-acme";
    repo = pname;
    rev = "v${version}";
    sha256 = "00m2w987czqj3l94834fpzc019pqi60jrqk4cnlfnc5mxjb0dbq1";
  };

  modSha256 = "0k3p11cji3p4nzr8aia8hp01wyx1qfx84259dwbfwg1b32ln8rkc";

  meta = with lib; {
    description = "Let's Encrypt client and ACME library written in Go";
    license = licenses.mit;
    homepage = "https://go-acme.github.io/lego/";
    maintainers = with maintainers; [ andrew-d ];
  };
}
