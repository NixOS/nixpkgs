{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "easyjson-unstable-${version}";
  version = "2018-08-23";
  goPackagePath = "github.com/mailru/easyjson";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "mailru";
    repo = "easyjson";
    rev = "60711f1a8329503b04e1c88535f419d0bb440bff";
    sha256 = "0234jp6134wkihdpdwq1hvzqblgl5khc1wp6dyi2h0hgh88bhdk1";
  };

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/mailru/easyjson";
    description = "Fast JSON serializer for golang";
    license = licenses.mit;
    maintainers = with maintainers; [ chiiruno ];
    platforms = platforms.all;
  };
}
