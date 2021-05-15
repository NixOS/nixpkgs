{ lib, stdenv, fetchFromGitHub, ffmpeg, libjpeg, libpng, pkg-config }:

stdenv.mkDerivation rec {
  pname = "harvid";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "x42";
    repo = "harvid";
    rev = "v${version}";
    sha256 = "0l1plfsfh2ixhlzg3hqqvjj42z7g422718a9kgbh7b4p882n71x7";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ ffmpeg libjpeg libpng ];

  makeFlags = [ "DESTDIR=$(out)" "libdir=\"/lib\"" ];

  postInstall = ''
    mkdir -p $out/bin
    mv $out/usr/local/bin/* $out/bin
    mv $out/usr/local/share $out/
    rm -r $out/usr
  '';

  meta = with lib; {
    description =
      "Decodes still images from movie files and serves them via HTTP";
    longDescription = ''
      harvid's intended use-case is to efficiently provide frame-accurate data
      and act as second level cache for rendering the video-timeline in Ardour,
      but it is not limited to that: it has applications for any task that
      requires a high-performance frame-accurate online image extraction
      processor.
    '';
    homepage = "http://x42.github.io/harvid";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mitchmindtree ];
  };
}
