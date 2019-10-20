{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gucci";
  version = "0.1.0";

  goPackagePath = "github.com/noqcks/gucci";

  src = fetchFromGitHub {
    owner = "noqcks";
    repo = "gucci";
    rev = version;
    sha256 = "0ksrmzb3iggc7gm51fl0jbb15d0gmpclslpkq2sl2xjzk29pkllq";
  };

  goDeps = ./deps.nix;

  buildFlagsArray = ''
    -ldflags=-X main.AppVersion=${version}
  '';

  meta = with stdenv.lib; {
    description = "A simple CLI templating tool written in golang";
    homepage = https://github.com/noqcks/gucci;
    license = licenses.mit;
    maintainers = [ maintainers.braydenjw ];
    platforms = platforms.unix;
  };
}

