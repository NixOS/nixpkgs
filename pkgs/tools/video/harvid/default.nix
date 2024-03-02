{ lib, stdenv, fetchFromGitHub, fetchpatch, ffmpeg_4, libjpeg, libpng, pkg-config }:

stdenv.mkDerivation rec {
  pname = "harvid";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "x42";
    repo = "harvid";
    rev = "v${version}";
    sha256 = "sha256-qt6aep7iMF8/lnlT2wLqu6LkFDqzdfsGLZvrOlXttG8=";
  };

  patches = [
    # Fix pending upstream inclusion to support parallel builds:
    #   https://github.com/x42/harvid/pull/10
    (fetchpatch {
      name = "parallel-build.patch";
      url = "https://github.com/x42/harvid/commit/a3f85c57ad2559558706d9b22989de36452704d9.patch";
      sha256 = "sha256-0aBfM/4XEqM7C1nFw996IVwaeL0tNgMUQ1C3kblOobI=";
    })
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ ffmpeg_4 libjpeg libpng ];

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
    mainProgram = "harvid";
  };
}
