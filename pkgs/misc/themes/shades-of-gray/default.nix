{ stdenv, fetchFromGitHub, gtk_engines, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "shades-of-gray-theme-${version}";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "WernerFP";
    repo = "Shades-of-gray-theme";
    rev = version;
    sha256 = "1m75m6aq4hh39m8qrmbkaw31j4gzkh63ial4xnhw2habf31av682";
  };

  buildInputs = [ gtk_engines ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    mkdir -p $out/share/themes
    cp -a Shades-of-gray* README.md preview_01.png $out/share/themes/
  '';

  meta = with stdenv.lib; {
    description = "A flat dark GTK-theme with ergonomic contrasts";
    homepage = https://github.com/WernerFP/Shades-of-gray-theme;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
