{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "cli53-${version}";
  version = "0.8.8";

  goPackagePath = "github.com/barnybug/cli53";

  src = fetchFromGitHub {
    owner = "barnybug";
    repo = "cli53";
    rev = version;
    sha256 = "1hbx64rn25qzp2xlfwv8xaqyfcax9b6pl30j9vciw7cb346i84gc";
  };

  buildPhase = ''
    pushd go/src/${goPackagePath}/cmd/cli53
    go get .
    popd
  '';

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "CLI tool for the Amazon Route 53 DNS service";
    homepage = https://github.com/barnybug/cli53;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ benley ];
  };
}
