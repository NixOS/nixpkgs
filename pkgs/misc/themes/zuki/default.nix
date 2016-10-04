{ stdenv, fetchFromGitHub, gnome3, gdk_pixbuf, gtk_engines, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "zuki-themes-${version}";
  version = "${gnome3.version}.${date}";
  date = {
    "3.18" = "2016-06-21";
    "3.20" = "2016-07-01";
  }."${gnome3.version}";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = "zuki-themes";
    rev = {
      "3.18" = "5c83a847ad8fab0fe0b82ed2a7db429655ac9c10";
      "3.20" = "dda1726ac7b556df2ef9696e530f8c2eaa0aed37";
    }."${gnome3.version}";
    sha256 = {
      "3.18" = "1x9zrx5dqq8kivhqj5kjwhy4vwr899pri6jvwxbff5hibvyc7ipy";
      "3.20" = "0p7db8a2ni494vwp3b7av7d214fnynf6gr976qma6h9x4ck3phiz";
    }."${gnome3.version}";
  };

  buildInputs = [ gdk_pixbuf gtk_engines gtk-engine-murrine ];

  dontBuild = true;

  installPhase = ''
    install -dm 755 $out/share/themes
    cp -va Zuki* $out/share/themes/
  '';

  meta = {
    description = "A selection of themes for GTK3, gnome-shell and more";
    homepage = "https://github.com/lassekongo83/zuki-themes";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
