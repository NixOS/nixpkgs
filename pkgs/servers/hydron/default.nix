{ lib, buildGoModule, fetchFromGitHub, pkgconfig, pth, ffmpeg-full }:

buildGoModule rec {
  pname = "hydron";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "bakape";
    repo = "hydron";
    rev = "v${version}";
    sha256 = "0hij7xkz09qmfx8qacwxgkdpnc3anc852vwzq2lhv8zx6aikdm8l";
  };

  modSha256 = "1565hcpwnaxjm9jap5628whp7ma1gdcq7jqzqkl1cznggg9w9a30";
  enableParallelBuilding = true;
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ pth ];
  propagatedBuildInputs = [ ffmpeg-full ];

  meta = with lib; {
    homepage = "https://github.com/bakape/hydron";
    description = "High performance media tagger and organizer";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ chiiruno ];
    platforms = platforms.all;
  };
}
