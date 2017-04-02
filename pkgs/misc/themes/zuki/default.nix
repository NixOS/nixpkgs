{ stdenv, fetchFromGitHub, gnome3, gdk_pixbuf, gtk_engines, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "zuki-themes-${version}";
  version = "${gnome3.version}.${date}";
  date = {
    "3.20" = "2017-02-09";
    "3.22" = "2017-02-17";
  }."${gnome3.version}";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = "zuki-themes";
    rev = {
      "3.20" = "b9106c3c05012b7e91394819ca550def3357d2eb";
      "3.22" = "fc3cf7c372bcc439870c4785f91b8ea7af73e1cc";
    }."${gnome3.version}";
    sha256 = {
      "3.20" = "03k18p25gsscv05934vs0py26vpcrx93wi5bj6di277c6kwgjzxg";
      "3.22" = "02ppk8wsx0k7j3zgmcb1l8jgij0m5rdkrahfv884jxkyjr6wwgs5";
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
