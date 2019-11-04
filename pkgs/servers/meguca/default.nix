{ lib, buildGoModule, fetchFromGitHub, pkgconfig, nodePackages, pth
, ffmpeg-full, opencv, geoip }:

buildGoModule rec {
  pname = "meguca";
  version = "6.5.3";

  src = fetchFromGitHub {
    owner = "bakape";
    repo = "meguca";
    rev = "v${version}";
    sha256 = "0fbldmbjg33whgphkpngx19vs6ch0b709li1fhgxzqik0qzy37fs";
  };

  modSha256 = "0ic3nc6pil3rw4spl9va6sykfk71a4y8qa9j6h8ppx8a095rq9w4";
  enableParallelBuilding = true;
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ pth ffmpeg-full opencv geoip ];

  postBuild = ''
    ln -sf ${nodePackages.meguca}/lib/node_modules/meguca/node_modules
    sed -i "/npm install --progress false --depth 0/d" Makefile
    make client
  '';

  postInstall = ''
    mkdir -p $out/share
    rm -rf www/videos
    cp -r www $out/share
  '';

  meta = with lib; {
    homepage = "https://github.com/bakape/meguca";
    description = "Anonymous realtime imageboard focused on high performance, free speech, and transparent moderation";
    license = licenses.agpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ chiiruno ];
  };
}
