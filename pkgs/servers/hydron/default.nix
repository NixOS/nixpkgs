{ stdenv, buildGoPackage, fetchFromGitHub, pkgconfig, ffmpeg-full, graphicsmagick
, quicktemplate, go-bindata, easyjson }:

buildGoPackage rec {
  name = "hydron-unstable-${version}";
  version = "2018-10-08";
  goPackagePath = "github.com/bakape/hydron";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "bakape";
    repo = "hydron";
    rev = "0a834bcaf9af3a6bac8873fad981aa3736115258";
    sha256 = "154s1jjcdcwaxial2gsxaqb8bc1hwagz844ld2jr928jxj7ffqww";
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
