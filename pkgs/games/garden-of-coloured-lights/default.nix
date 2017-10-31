{ stdenv, fetchurl, autoconf, automake, allegro }:

stdenv.mkDerivation rec {
  name = "garden-of-coloured-lights-${version}";
  version = "1.0.9";

  buildInputs = [ allegro autoconf automake ];

  prePatch = ''
    noInline='s/inline //'
    sed -e "$noInline" -i src/stuff.c
    sed -e "$noInline" -i src/stuff.h
  '';

  src = fetchurl {
    url = "mirror://sourceforge/garden/${version}/garden-${version}.tar.gz";
    sha256 = "1qsj4d7r22m5f9f5f6cyvam1y5q5pbqvy5058r7w0k4s48n77y6s";
  };

  meta = with stdenv.lib; {
    description = "Old-school vertical shoot-em-up / bullet hell";
    homepage = http://garden.sourceforge.net/drupal/;
    maintainers = with maintainers; [ profpatsch ];
    license = licenses.gpl3;
  };

}
