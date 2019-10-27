{ stdenv, buildGoPackage, fetchFromGitHub, pkgconfig, ffmpeg-full, graphicsmagick
, quicktemplate, go-bindata, easyjson }:

buildGoPackage {
  pname = "hydron-unstable";
  version = "2019-02-17";
  goPackagePath = "github.com/bakape/hydron";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "bakape";
    repo = "hydron";
    rev = "824789fb108966432e507143db39b358dd7ff233";
    sha256 = "1xxykjf5iyavm12gd6nx4j8x2mlzzn7x8vm0j5009lsir98qr5zn";
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
