{ stdenv, fetchgit, cmake, mesa, sfml, fribidi, taglib }:
stdenv.mkDerivation rec {
  name = "mars-${version}-${rev}";
  version = "0.7.5";
  rev = "c855d04409";
  src = fetchgit {
    url = "https://github.com/thelaui/M.A.R.S..git";
    inherit rev;
    sha256 = "70fc4b5823f2efb03e0bcd3fe82dee88ee93ddfd81d53de0d7eb3fe02793d65e";
  };
  buildInputs = [ cmake mesa sfml fribidi taglib ];
  patches = [ ./unbind_fix.patch ];
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
  };
}
