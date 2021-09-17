{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "go-toml";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "pelletier";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1ENmSeo3TtTvhgwtbmq+O9n9fD/FqSUiCrSplkJNTTg=";
  };

  goPackagePath = "github.com/pelletier/go-toml";

  excludedPackages = [ "cmd/tomltestgen" ];

  meta = with lib; {
    description = "Go library for the TOML language";
    homepage = "https://github.com/pelletier/go-toml";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
