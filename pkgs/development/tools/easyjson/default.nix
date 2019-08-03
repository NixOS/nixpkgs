{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "easyjson-unstable-${version}";
  version = "2019-02-21";
  goPackagePath = "github.com/mailru/easyjson";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "mailru";
    repo = "easyjson";
    rev = "6243d8e04c3f819e79757e8bc3faa15c3cb27003";
    sha256 = "160sj5pq4bv9jshniimkd5f9zcg6xrbgb027lhr9l895nsv4dlib";
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
