{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "terraform-lsp";
  version = "0.0.12";

  src = fetchFromGitHub {
    owner = "juliosueiras";
    repo = pname;
    rev = "v${version}";
    sha256 = "111350jbq0dp0qhk48j12hrlisd1fwzqpcv357igrbqf6ki7r78q";
  };

  goPackagePath = "github.com/juliosueiras/terraform-lsp";

  ldflags = [ "-s" "-w" "-X main.Version=${version}" "-X main.GitCommit=${src.rev}" ];

  meta = with lib; {
    description = "Language Server Protocol for Terraform";
    homepage = "https://github.com/juliosueiras/terraform-lsp";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
