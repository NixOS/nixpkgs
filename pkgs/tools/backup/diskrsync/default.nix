{ buildGoPackage, fetchFromGitHub, stdenv }:

buildGoPackage rec {

  name = "${pname}-${version}";
  pname = "diskrsync";
  version = "unstable-2017-09-27";

  src = fetchFromGitHub {
    owner = "dop251";
    repo = pname;
    rev = "45818879a98edceaa915739c1b8ece58e4b34866";
    sha256 = "0jvx5manh1z0shvg616vw0n5cp5v4bljk6h3mmw3bdskg9r076lh";
  };

  goPackagePath = "github.com/dop251/diskrsync";
  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Rsync for block devices and disk images";
    homepage = https://github.com/dop251/diskrsync;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };

}
