{ stdenv, fetchurl, pkgconfig, intltool, gtk2 }:

stdenv.mkDerivation rec {

  name = "yad-0.25.1";

  src = fetchurl {
    url = "http://yad.googlecode.com/files/${name}.tar.xz";
    sha256 = "1pljs9799xa2w3y2vjg93gqkv76z0pjh947djd7179yq3kryb57a";
  };

  configureFlags = [
    "--enable-icon-browser"
  ];

  # for gcc5: c11 inline semantics breaks the build
  NIX_CFLAGS_COMPILE = "-fgnu89-inline";

  buildInputs = [ gtk2 ];

  nativeBuildInputs = [ pkgconfig intltool ];

  preFixup = "rm $out/share/icons/hicolor/icon-theme.cache";

  meta = {
    homepage = "http://code.google.com/p/yad/";
    description = "GUI dialog tool for shell scripts";
    longDescription = ''
      Yad (yet another dialog) is a GUI dialog tool for shell scripts. It is a
      fork of Zenity with many improvements, such as custom buttons, additional
      dialogs, pop-up menu in notification icon and more.
    '';

    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [ smironov ];
  };
}

