{ stdenvNoCC, lib, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "zsh-fast-syntax-highlighting";
  version = "1.54";

  src = fetchFromGitHub {
    owner = "zdharma";
    repo = "fast-syntax-highlighting";
    rev = "v${version}";
    sha256 = "019hda2pj8lf7px4h1z07b9l6icxx4b2a072jw36lz9bh6jahp32";
  };

  #adapted from https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=zsh-fast-syntax-highlighting-git
  installPhase = ''
    _plugindir="$out/share/zsh/site-functions"

    cd "$src"
    install -dm0755 "$_plugindir"
    install -m0644 -- {,_,-}fast-* "$_plugindir"

    cp -r {.,$_plugindir}/chroma
    cp -r {.,$_plugindir}/themes
  '';

  meta = with lib; {
    description = "Syntax-highlighting for Zshell";
    homepage = "https://github.com/zdharma/fast-syntax-highlighting";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
