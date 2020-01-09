{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terraform-lsp";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "juliosueiras";
    repo = pname;
    rev = "v${version}";
    sha256 = "1m133fznf58fkjl5yx0gxa3cjfb0h8f9fv760c9h1d5cg279bghk";
  };

  modSha256 = "1mb3169vdlv4h10k15pg88s48s2b6y7v5frk9j9ahg52grygcqb2";

  meta = with lib; {
    description = "Language Server Protocol for Terraform";
    homepage = "https://github.com/juliosueiras/terraform-lsp";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
