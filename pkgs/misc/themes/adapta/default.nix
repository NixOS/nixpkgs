{ stdenv, fetchFromGitHub, autoreconfHook, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "adapta-gtk-theme-${version}";
  version = "3.21.2";

  meta = with stdenv.lib; {
    description = "An adaptive GTK+ theme based on Material Design";
    homepage = "https://github.com/tista500/Adapta";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.SShrike ];
  };

  src = fetchFromGitHub {
    owner = "tista500";
    repo = "Adapta";
    rev = "c48da995abc46087c22b05d2cdb0975d10774641";
    sha256 = "17w9nsrwqwgafswyvhc5h8ld2ggi96ix5fjv6yf1hfz3l1ln9qg7";
  };

  preferLocalBuild = true;
  buildInputs = [ gtk-engine-murrine ];
  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = "--enable-chrome --disable-unity";
}
