{ stdenv, fetchurl, SDL, ftgl, pkgconfig, libpng, libjpeg, pcre, SDL_image, glew, mesa }:

let
  name = "logstalgia-1.0.3";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://logstalgia.googlecode.com/files/logstalgia-1.0.3.tar.gz";
    sha256 = "1sv1cizyw3y7g558hnvvcal8z889gbr82v4qj35hxdmrzygqlcyk";
  };

  buildInputs = [glew SDL ftgl pkgconfig libpng libjpeg pcre SDL_image mesa];

  meta = {
    homepage = "http://code.google.com/p/logstalgia/";
    description = "website traffic visualization tool";
    license = stdenv.lib.licenses.gpl3Plus;

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

    platforms = stdenv.lib.platforms.gnu;
    maintainers = [];
  };
}
