{ stdenv, fetchgit, cmake, libGLU_combined, sfml, fribidi, taglib }:
stdenv.mkDerivation rec {
  name = "mars-${version}-${rev}";
  version = "0.7.5";
  rev = "c855d04409";
  src = fetchgit {
    url = "https://github.com/thelaui/M.A.R.S..git";
    inherit rev;
    sha256 = "1r4c5gap1z2zsv4yjd34qriqkxaq4lb4rykapyzkkdf4g36lc3nh";
  };
  buildInputs = [ cmake libGLU_combined sfml fribidi taglib ];
  patches = [
    ./unbind_fix.patch
    ./fix-gluortho2d.patch
  ];
  installPhase = ''
    cd ..
    find -name '*.svn' -exec rm -rf {} \;
    mkdir -p "$out/share/mars/"
    mkdir -p "$out/bin/"
    cp -rv data resources credits.txt license.txt "$out/share/mars/"
    cp -v mars "$out/bin/mars.bin"
    cat << EOF > "$out/bin/mars"
    #! /bin/sh
    cd "$out/share/mars/"
    exec "$out/bin/mars.bin" "\$@"
    EOF
    chmod +x "$out/bin/mars"
  '';
  meta = with stdenv.lib; {
    homepage = http://mars-game.sourceforge.net/;
    description = "A game about fighting with ships in a 2D space setting";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.astsmtl ];
    platforms = platforms.linux;
  };
}
