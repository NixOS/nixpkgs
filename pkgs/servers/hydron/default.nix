{ stdenv, buildGoPackage, fetchFromGitHub, pkgconfig, ffmpeg-full, graphicsmagick
, quicktemplate, go-bindata, easyjson }:

buildGoPackage rec {
  name = "hydron-unstable-${version}";
  version = "2018-08-18";
  goPackagePath = "github.com/bakape/hydron";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "bakape";
    repo = "hydron";
    rev = "78257f1c1f34cdad1931531601163071f7f29aa9";
    sha256 = "0rpvbayx48xncy70vzbxn3cs0lslza0i3hxmywlngyl17da97bf0";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ffmpeg-full graphicsmagick quicktemplate go-bindata easyjson ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/bakape/hydron";
    description = "High performance media tagger and organizer";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ chiiruno ];
    platforms = platforms.all;
  };
}
