{ stdenv, fetchurl, ncurses, customConfig ? null }:

stdenv.mkDerivation rec {

  name = "dvtm-0.15";

  src = fetchurl {
    url = "${meta.homepage}/${name}.tar.gz";
    sha256 = "0475w514b7i3gxk6khy8pfj2gx9l7lv2pwacmq92zn1abv01a84g";
  };

  postPatch = stdenv.lib.optionalString (customConfig != null) ''
    cp ${builtins.toFile "config.h" customConfig} ./config.h
  '';

  buildInputs = [ ncurses ];

  prePatch = ''
    substituteInPlace Makefile \
      --replace /usr/share/terminfo $out/share/terminfo
  '';

  installPhase = ''
    make PREFIX=$out install
  '';

  meta = with stdenv.lib; {
    description = "Dynamic virtual terminal manager";
    homepage = http://www.brain-dump.org/projects/dvtm;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.vrthra ];
  };
}
