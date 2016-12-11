{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "vault-${version}";
  version = "0.6.3";

  goPackagePath = "github.com/hashicorp/vault";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "vault";
    rev = "v${version}";
    sha256 = "0cbaws106v5dxqjii1s9rmk55pm6y34jls35iggpx0pp1dd433xy";
  };

  buildFlagsArray = ''
    -ldflags=
      -X github.com/hashicorp/vault/version.GitCommit=${version}
  '';

  meta = with stdenv.lib; {
    homepage = https://www.vaultproject.io;
    description = "A tool for managing secrets";
    license = licenses.mpl20;
    maintainers = with maintainers; [ rushmorem offline ];
  };
}
