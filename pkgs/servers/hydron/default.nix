{ stdenv, buildGoPackage, fetchFromGitHub, pkgconfig, ffmpeg-full, graphicsmagick
, quicktemplate, go-bindata, easyjson }:

buildGoPackage rec {
  name = "hydron-unstable-${version}";
  version = "2018-07-30";
  goPackagePath = "github.com/bakape/hydron";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "bakape";
    repo = "hydron";
    rev = "586af9da1e551b2a7128c154200e2e2e32d1af7e";
    sha256 = "1lif63kcllsbmv06n3b8ayx89k90lximyp23108blcq456wrf0zi";
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
