{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "easyjson-unstable-${version}";
  version = "2018-07-30";
  goPackagePath = "github.com/mailru/easyjson";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "mailru";
    repo = "easyjson";
    rev = "03f2033d19d5860aef995fe360ac7d395cd8ce65";
    sha256 = "0r62ym6m1ijby7nwplq0gdnhak8in63njyisrwhr3xpx9vkira97";
  };

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/mailru/easyjson;
    description = "Fast JSON serializer for golang";
    license = licenses.mit;
    maintainers = with maintainers; [ chiiruno ];
    platforms = platforms.all;
  };
}
