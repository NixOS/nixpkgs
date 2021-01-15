{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool , pkgconfig, glib, libxml2, libxslt, getopt, libiconv, gettext, nix, disnix, libnixxml }:

stdenv.mkDerivation rec {
  version="2020-07-04";
  name = "dydisnix-${version}";

  src = fetchFromGitHub {
    owner = "svanderburg";
    repo = "dydisnix";
    rev = "e99091f1c2329d562097e35faedee80622d387f0";
    sha256 = "sha256-XKab2hNGtWDkIEMxE1vMvqQBTP9BvHTabBVfzpH57h0=";
  };

  nativeBuildInputs = [ pkgconfig autoconf automake libtool ];
  buildInputs = [ glib libxml2 libxslt getopt nix disnix libiconv gettext libnixxml ];
  preConfigure = ''
    ./bootstrap
  '';

  meta = {
    description = "A toolset enabling self-adaptive redeployment on top of Disnix";
    longDescription = "Dynamic Disnix is a (very experimental!) prototype extension framework for Disnix supporting dynamic (re)deployment of service-oriented systems.";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.tomberek ];
    platforms = lib.platforms.unix;
  };
}
