{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cli";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "cli";
    repo = "cli";
    rev = "v${version}";
    sha256 = "050wqjng0l42ilaiglwm1mzrrmnk0bg9icnzq9sm88axgl4xpmdy";
  };

  vendorSha256 = "0s99bjmsafnzhl3s2lcybxgsw1s4i1h3vh6p40gz4vsfhndidqrq";

  subPackages = [ "cmd/gh" ];

  meta = with lib; {
    description = "GitHub’s official command line tool";
    homepage = "https://cli.github.com";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.koral ];
  };
}
