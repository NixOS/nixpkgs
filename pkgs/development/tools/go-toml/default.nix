{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "go-toml";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "pelletier";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-O3gfQon8ktObLVED4A5sCSOw8K1NIXP3a5AsLq3Svb4=";
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
