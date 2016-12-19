{ stdenv, fetchFromGitHub, gnome3, gdk_pixbuf, gtk_engines, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "zuki-themes-${version}";
  version = "${gnome3.version}.${date}";
  date = {
    "3.20" = "2016-07-01";
    "3.22" = "2016-10-20";
  }."${gnome3.version}";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = "zuki-themes";
    rev = {
      "3.20" = "dda1726ac7b556df2ef9696e530f8c2eaa0aed37";
      "3.22" = "a48f0f12f81c49b480f82369ae45cfa49d78b143";
    }."${gnome3.version}";
    sha256 = {
      "3.20" = "0p7db8a2ni494vwp3b7av7d214fnynf6gr976qma6h9x4ck3phiz";
      "3.22" = "05sa5ighq01krbgfd4lddxvbhfqk5x5kgw6jnxwvx9rmmff713s1";
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
