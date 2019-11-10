{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "mkcert";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = pname;
    rev = "v${version}";
    sha256 = "0xcmvzh5lq8vs3b0f1zw645fxdr8471v7prl1656q02v38f58ly7";
  };

  goPackagePath = "github.com/FiloSottile/mkcert";

  meta = with lib; {
    homepage = https://github.com/FiloSottile/mkcert;
    description = "A simple tool for making locally-trusted development certificates";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
