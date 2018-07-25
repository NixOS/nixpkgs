{ stdenv, buildGoPackage, fetchFromGitHub, pkgconfig, ffmpeg-full, graphicsmagick
, quicktemplate, go-bindata, easyjson }:

buildGoPackage rec {
  name = "hydron-unstable-${version}";
  version = "2018-07-15";
  goPackagePath = "github.com/bakape/hydron";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    rev = "3906ace0b4cf48ba9acccf372377c7feb0665be4";
    owner = "bakape";
    repo = "hydron";
    sha256 = "079a88740wxgq73sq8w96zppfng7af76k7h484x3w695qk83j33r";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ffmpeg-full graphicsmagick quicktemplate go-bindata easyjson ];

  # Temporary workaround for https://github.com/NixOS/nixpkgs/issues/43593
  preBuild = ''
    rm go/src/github.com/bakape/hydron/ico.syso
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/bakape/hydron";
    description = "High performance media tagger and organizer";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ chiiruno ];
    platforms = platforms.all;
  };
}
