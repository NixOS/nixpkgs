{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "geniveev";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "svrana";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-y9vIXkah2+Wt28qTjAQaHDea9EB2IDiLuK3URnA2NbM=";
  };

  vendorHash = "sha256-T+b09q6WOTXdYPnmHxCG9ps2lsQyttk4t7KYTZpsQdI=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "An easy to use, language-agnostic code generation tool, powered by Go templates and an intuitive CLI.";
    homepage = "https://github.com/svrana/geniveev";
    license = licenses.mit;
    maintainers = with maintainers; [ svrana ];
  };
}
