{ lib, stdenv, fetchurl, SDL2, ftgl, pkg-config, libpng, libjpeg, pcre, SDL2_image, glew
, libGLU, libGL, boost, glm, freetype }:

stdenv.mkDerivation rec {
  pname = "logstalgia";
  version = "1.1.2";

  src = fetchurl {
    url = "https://github.com/acaudwell/Logstalgia/releases/download/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "1agwjlwzp1c86hqb1p7rmzqzhd3wpnyh8whsfq4sbx01wj0l0gzd";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glew SDL2 ftgl libpng libjpeg pcre SDL2_image libGLU libGL boost
                  glm freetype ];

  meta = with lib; {
    homepage = "https://logstalgia.io/";
    description = "Website traffic visualization tool";
    license = licenses.gpl3Plus;

    longDescription = ''
      Logstalgia is a website traffic visualization that replays or
      streams web-server access logs as a pong-like battle between the
      web server and an never ending torrent of requests.

      Requests appear as colored balls (the same color as the host)
      which travel across the screen to arrive at the requested
      location. Successful requests are hit by the paddle while
      unsuccessful ones (eg 404 - File Not Found) are missed and pass
      through.

      The paths of requests are summarized within the available space by
      identifying common path prefixes. Related paths are grouped
      together under headings. For instance, by default paths ending in
      png, gif or jpg are grouped under the heading Images. Paths that
      don’t match any of the specified groups are lumped together under
      a Miscellaneous section.
    '';

    platforms = platforms.gnu ++ platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
