{ stdenv, fetchurl, automake, autoconf, SDL, SDL_image, SDL_mixer, SDL_net, SDL_ttf, pango
, gettext, zlib, boost, freetype, libpng, pkgconfig, lua, dbus, fontconfig, libtool
, fribidi, asciidoc }:

stdenv.mkDerivation rec {
  pname = "wesnoth";
  version = "1.8.6";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/sourceforge/${pname}/${name}.tar.bz2";
    sha256 = "10c01ys846zsy831gprdy2nx3qlzv65s4jy99lw6misak3x07rjg";
  };

  buildInputs = [ SDL SDL_image SDL_mixer SDL_net SDL_ttf pango gettext zlib boost fribidi
                  automake autoconf freetype libpng pkgconfig lua dbus fontconfig libtool ];

  # The preInstall sed substitution fix errors which I
  # believe arise from autotools version mismatches.  Rather than
  # hunt for the correct automake and autoconf versions these changes
  # make the build work with the versions current in Nixpkgs.
  preInstall = ''
    sed -i -e s,@MKINSTALLDIRS@,`pwd`/config/mkinstalldirs, po/*/Makefile
  '';

  configurePhase = ''
    ./autogen.sh --prefix=$out --with-boost=${boost} \
                 --with-preferences-dir=.${pname} \
                 --with-datadir-name=${pname}
  '';

  # Make the package build with the gcc currently available in Nixpkgs.
  NIX_CFLAGS_COMPILE = "-Wno-ignored-qualifiers";

  meta = with stdenv.lib; {
    description = "The Battle for Wesnoth, a free, turn-based strategy game with a fantasy theme";
    longDescription = ''
      The Battle for Wesnoth is a Free, turn-based tactical strategy
      game with a high fantasy theme, featuring both single-player, and
      online/hotseat multiplayer combat. Fight a desperate battle to
      reclaim the throne of Wesnoth, or take hand in any number of other
      adventures.
    '';

    homepage = http://www.wesnoth.org/;
    license = licenses.gpl2;
    maintainers = [ maintainers.kkallio ];
    platforms = platforms.linux;
  };
}
