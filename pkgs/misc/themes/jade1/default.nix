{ stdenv, fetchFromGitHub, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "theme-jade1-${version}";
  version = "3.3";

  src = fetchFromGitHub {
    owner = "madmaxms";
    repo = "theme-jade-1";
    rev = "v${version}";
    sha256 = "06w06dvzs1llmzpyz3c5yycsw3gslsgikalfcq5l92d72z4kzfw7";
  };

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    mkdir -p $out/share/themes
    cp -a Jade-1 $out/share/themes
  '';

  meta = with stdenv.lib; {
    description = "A fork of the original Linux Mint theme with dark menus, more intensive green and some other modifications";
    homepage = https://github.com/madmaxms/theme-jade-1;
    license = with licenses; [ gpl3 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
