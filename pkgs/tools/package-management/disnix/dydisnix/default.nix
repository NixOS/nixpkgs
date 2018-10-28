{ stdenv, fetchFromGitHub, autoconf, automake, libtool , pkgconfig, glib, libxml2, libxslt, getopt, nixUnstable, disnix }:

stdenv.mkDerivation rec {
  version="unstable-2018-04-26";
  name = "dydisnix-${version}";

  src = fetchFromGitHub {
    owner = "svanderburg";
    repo = "dydisnix";
    rev = "671db6acbb782404dc45b8b642887e13660a237b";
    sha256 = "0cydvhjy9jg7gz36wh8crvbwadlv59n498p7rh00kff397lpkrxw";
  };

  nativeBuildInputs = [ pkgconfig autoconf automake libtool ];
  buildInputs = [ glib libxml2 libxslt getopt nixUnstable disnix ];
  preConfigure = ''
    ./bootstrap
  '';

  meta = {
    description = "A toolset enabling self-adaptive redeployment on top of Disnix";
    longDescription = "Dynamic Disnix is a (very experimental!) prototype extension framework for Disnix supporting dynamic (re)deployment of service-oriented systems.";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.tomberek ];
    platforms = stdenv.lib.platforms.unix;
  };
}
