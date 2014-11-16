{ stdenv, fetchurl, SDL, ftgl, pkgconfig, libpng, libjpeg, pcre, SDL_image, glew
, mesa, boost, glm }:

stdenv.mkDerivation rec {
  name = "logstalgia-${version}";
  version = "1.0.6";

  src = fetchurl {
    url = "https://github.com/acaudwell/Logstalgia/releases/download/${name}/${name}.tar.gz";
    sha256 = "0d2zhn0q26rv2nb3hdbg0mb69l66g8pkys5is6rb0r6f5is986x8";
  };

  buildInputs = [ glew SDL ftgl pkgconfig libpng libjpeg pcre SDL_image mesa boost
                  glm ];

  meta = with stdenv.lib; {
    homepage = http://code.google.com/p/logstalgia;
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
