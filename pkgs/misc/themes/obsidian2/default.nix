{ stdenv, fetchFromGitHub, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "theme-obsidian2-${version}";
  version = "2.7";

  src = fetchFromGitHub {
    owner = "madmaxms";
    repo = "theme-obsidian-2";
    rev = "v${version}";
    sha256 = "0my3q7xvi6m257x489wync0y5n8n1kig4xg5gfrb905avhxj5frs";
  };

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  postPatch = ''
    sed -i -e 's|Obsidian-2-Local|Obsidian-2|' Obsidian-2/index.theme
  '';

  installPhase = ''
    mkdir -p $out/share/themes
    cp -a Obsidian-2 $out/share/themes
  '';

  meta = with stdenv.lib; {
    description = "Gnome theme, based upon Adwaita-Maia dark skin";
    homepage = https://github.com/madmaxms/theme-obsidian-2;
    license = with licenses; [ gpl3 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
