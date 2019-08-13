{ stdenv, fetchFromGitHub, autoconf, automake, pkgconfig,
  gtk-engine-murrine, gtk3
}:

stdenv.mkDerivation rec {
  name = "solarc-gtk-theme-${version}";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "schemar";
    repo = "solarc-theme";
    rev = "d1eb117325b8e5085ecaf78df2eb2413423fc643";
    sha256 = "005b66whyxba3403yzykpnlkz0q4m154pxpb4jzcny3fggy9r70s";
  };

  nativeBuildInputs = [ autoconf automake pkgconfig gtk3 ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine gtk3 ];

  buildPhase = ''
    ./autogen.sh --prefix=$out
  '';

  meta = with stdenv.lib; {
    description = "Solarized version of the Arc theme";
    homepage = https://github.com/schemar/solarc-theme;
    license = licenses.gpl3;
    maintainers = [ maintainers.bricewge ];
    platforms = platforms.linux;
  };
}
