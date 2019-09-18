{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terraform-lsp";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "juliosueiras";
    repo = pname;
    rev = "v${version}";
    sha256 = "1nalypaw64kdv5zmmb0xgkajhs2gf71ivbxvgwpgvlv2lyidawx5";
  };

  modSha256 = "1mb3169vdlv4h10k15pg88s48s2b6y7v5frk9j9ahg52grygcqb2";

  meta = with lib; {
    description = "Language Server Protocol for Terraform";
    homepage = "https://github.com/juliosueiras/terraform-lsp";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
