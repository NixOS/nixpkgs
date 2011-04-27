{ stdenv, fetchurl, cmake, mesa, sfml_svn, fribidi, taglib }:
stdenv.mkDerivation rec {
  name = "mars-${version}";
  version = "0.7.2";
  src = fetchurl {
    url = "mirror://sourceforge/mars-game/mars_source_${version}.tar.gz";
    sha256 = "0k4bfa7zay4w07hr1n4fx47xh2zy1ch5l7byvyvql21g244pjv5y";
  };
  buildInputs = [ cmake mesa sfml_svn fribidi taglib ];
  installPhase = ''
    cd ..
    find -name '*.svn' -exec rm -rf {} \;
    ensureDir "$out/share/mars/"
    ensureDir "$out/bin/"
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
