{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "terraform-lsp";
  version = "0.0.10";

  src = fetchFromGitHub {
    owner = "juliosueiras";
    repo = pname;
    rev = "v${version}";
    sha256 = "1j69j1pkd0q6bds1c6pcaars5hl3hk93q2p31mymkzmy640k8zfn";
  };

  goPackagePath = "github.com/juliosueiras/terraform-lsp";

  buildFlagsArray = [ "-ldflags=-s -w -X main.Version=${version} -X main.GitCommit=${src.rev}" ];

  meta = with lib; {
    description = "Language Server Protocol for Terraform";
    homepage = "https://github.com/juliosueiras/terraform-lsp";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
