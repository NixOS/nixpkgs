{ stdenv, fetchFromGitHub, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "theme-jade1-${version}";
  version = "3.2";

  src = fetchFromGitHub {
    owner = "madmaxms";
    repo = "theme-jade-1";
    rev = "v${version}";
    sha256 = "0lf8cawn2s2x1b9af0cznhqzx3dsr8h18srcwjz7af3y5daxf311";
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
