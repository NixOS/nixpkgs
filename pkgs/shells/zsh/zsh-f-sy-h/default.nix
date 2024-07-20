{ stdenvNoCC, lib, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "zsh-f-sy-h";
  version = "1.67";

  src = fetchFromGitHub {
    owner = "z-shell";
    repo = "F-Sy-H";
    rev = "v${version}";
    sha256 = "0bcsc4kgda577fs3bnvymmxdz3z5mf19pn8ngfqsklabnf79f5nf";
  };

  strictDeps = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    plugindir="$out/share/zsh/site-functions"

    mkdir -p "$plugindir"
    cp -r -- F-Sy-H.plugin.zsh chroma functions share themes "$plugindir"/
  '';

  meta = with lib; {
    description = "Feature-rich Syntax Highlighting for Zsh";
    homepage = "https://github.com/z-shell/F-Sy-H";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mrfreezeex ];
    platforms = platforms.unix;
  };
}
