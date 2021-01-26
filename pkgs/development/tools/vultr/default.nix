{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "vultr";
  version = "2.0.2";
  goPackagePath = "github.com/JamesClonk/vultr";

  src = fetchFromGitHub {
    owner = "JamesClonk";
    repo = "vultr";
    rev = "v${version}";
    sha256 = "0br8nxi9syraarp4hzav9a3p4zxhyi45cq5dsclzxi3fga2l6mqg";
  };

  meta = {
    description = "A command line tool for Vultr services, a provider for cloud virtual private servers";
    homepage = "https://github.com/JamesClonk/vultr";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.zauberpony ];
  };
}
