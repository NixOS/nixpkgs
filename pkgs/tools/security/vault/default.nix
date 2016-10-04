{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "vault-${version}";
  version = "0.6.1";

  goPackagePath = "github.com/hashicorp/vault";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "vault";
    rev = "v${version}";
    sha256 = "06xf2dpn0q398qb6wbh9j1wjl5smqq9nrrn2039g48haqm8853jx";
  };

  buildFlagsArray = ''
    -ldflags=
      -X github.com/hashicorp/vault/version.GitCommit=${version}
  '';

  meta = with stdenv.lib; {
    homepage = https://www.vaultproject.io;
    description = "A tool for managing secrets";
    license = licenses.mpl20;
    maintainers = [ maintainers.rushmorem ];
  };
}
