{ lib, stdenv, fetchurl, libxslt, docbook_xsl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "xdg-user-dirs-0.17";

  src = fetchurl {
    url = "https://user-dirs.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "13216b8rfkzak5k6bvpx6jvqv3cnbgpijnjwj8a8d3kq4cl0a1ra";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ libxslt docbook_xsl ];

  preFixup = ''
    # fallback values need to be last
    wrapProgram "$out/bin/xdg-user-dirs-update" \
      --suffix XDG_CONFIG_DIRS : "$out/etc/xdg"
  '';

  meta = with lib; {
    homepage = "http://freedesktop.org/wiki/Software/xdg-user-dirs";
    description = "A tool to help manage well known user directories like the desktop folder and the music folder";
    license = licenses.gpl2;
    maintainers = with maintainers; [ lethalman ];
    platforms = platforms.linux;
  };
}
