{ stdenv, fetchurl, libxslt, docbook_xsl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "xdg-user-dirs-0.17";

  src = fetchurl {
    url = "http://user-dirs.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "13216b8rfkzak5k6bvpx6jvqv3cnbgpijnjwj8a8d3kq4cl0a1ra";
  };

  buildInputs = [ libxslt docbook_xsl makeWrapper ];

  preFixup = ''
    wrapProgram "$out/bin/xdg-user-dirs-update" \
      --prefix XDG_CONFIG_DIRS : "$out/etc/xdg"
  '';

  meta = with stdenv.lib; {
    homepage = http://freedesktop.org/wiki/Software/xdg-user-dirs;
    description = "A tool to help manage well known user directories like the desktop folder and the music folder";
    license = licenses.gpl2;
    maintainers = with maintainers; [ lethalman ];
    platforms = platforms.linux;
  };
}
