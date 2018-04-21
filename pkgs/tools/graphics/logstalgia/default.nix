{ stdenv, fetchurl, SDL2, ftgl, pkgconfig, libpng, libjpeg, pcre, SDL2_image, glew
, libGLU_combined, boost, glm, freetype }:

stdenv.mkDerivation rec {
  name = "logstalgia-${version}";
  version = "1.1.1";

  src = fetchurl {
    url = "https://github.com/acaudwell/Logstalgia/releases/download/${name}/${name}.tar.gz";
    sha256 = "0nvnk8q9m2ignzwxak0vch88blywbx4znk70xf9fg38xa4rf94yn";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glew SDL2 ftgl libpng libjpeg pcre SDL2_image libGLU_combined boost
                  glm freetype ];

  meta = with stdenv.lib; {
    homepage = http://logstalgia.io/;
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

    platforms = platforms.gnu;
    maintainers = with maintainers; [ pSub ];
  };
}
