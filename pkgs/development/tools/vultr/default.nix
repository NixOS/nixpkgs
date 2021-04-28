{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "vultr";
  version = "2.0.3";
  goPackagePath = "github.com/JamesClonk/vultr";

  src = fetchFromGitHub {
    owner = "JamesClonk";
    repo = "vultr";
    rev = "v${version}";
    sha256 = "sha256-kyB6gUbc32NsSDqDy1zVT4HXn0pWxHdBOEBOSaI0Xro=";
  };

  meta = {
    description = "A command line tool for Vultr services, a provider for cloud virtual private servers";
    homepage = "https://github.com/JamesClonk/vultr";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.zauberpony ];
  };
}
