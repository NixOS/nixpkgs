{ stdenv, fetchFromGitHub, gnome3, gdk_pixbuf, gtk_engines, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "zuki-themes-${version}";
  version = "${gnome3.version}.${date}";
  date = {
    "3.20" = "2017-05-03";
    "3.22" = "2017-04-23";
    "3.24" = "2017-06-26";
  }."${gnome3.version}";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = "zuki-themes";
    rev = {
      "3.20" = "ce7ae498df7d5c81acaf48ed957b9f828356d58c";
      "3.22" = "e97f2c3cf75b5205bc5ecd6072696327169fde5d";
      "3.24" = "d25e0a2fb6e08ad107d8bb627451433362f2a830";
    }."${gnome3.version}";
    sha256 = {
      "3.20" = "0na81q9mc8kwn9m04kkcchrdr67087dqf3q155imhjgqrxjhh3w4";
      "3.22" = "195v0d2sgqh92c104xqm00p68yxp6kzp5mzx8q7s36bdv9p972q4";
      "3.24" = "0z5swi5aah3s4yinfglh491qydxgjkqwf6zxyz7k9c1d7lrvj3ww";
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
    homepage = https://github.com/lassekongo83/zuki-themes;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
