{stdenv, fetchurl, perl}:

stdenv.mkDerivation rec {
  name = "surfraw-2.2.9";

  src = fetchurl {
    url = "http://surfraw.alioth.debian.org/dist/surfraw-2.2.9.tar.gz";
    sha256 = "1fy4ph5h9kp0jzj1m6pfylxnnmgdk0mmdppw76z9jhna4jndk5xa";
  };

  configureFlags = [
    "--disable-opensearch"
  ];

  nativeBuildInputs = [ perl ];

  meta = {
    description = "Provides a fast unix command line interface to a variety of popular WWW search engines and other artifacts of power";
    homepage = http://surfraw.alioth.debian.org;
    maintainers = [];
    platforms = stdenv.lib.platforms.linux;
  };
}
