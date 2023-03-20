{ lib, stdenv, fetchurl, libxslt, docbook_xsl, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "xdg-user-dirs";
  version = "0.18";

  src = fetchurl {
    url = "https://user-dirs.freedesktop.org/releases/xdg-user-dirs-${version}.tar.gz";
    sha256 = "sha256-7G8G10lc26N6cyA5+bXhV4vLKWV2/eDaQO2y9SIg3zw=";
  };

  nativeBuildInputs = [ makeWrapper libxslt docbook_xsl ];

  preFixup = ''
    # fallback values need to be last
    wrapProgram "$out/bin/xdg-user-dirs-update" \
      --suffix XDG_CONFIG_DIRS : "$out/etc/xdg"
  '';

  meta = with lib; {
    homepage = "http://freedesktop.org/wiki/Software/xdg-user-dirs";
    description = "A tool to help manage well known user directories like the desktop folder and the music folder";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
