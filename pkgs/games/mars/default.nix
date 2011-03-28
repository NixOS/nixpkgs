{ stdenv, fetchurl, cmake, mesa, sfml_svn, fribidi, taglib }:
stdenv.mkDerivation rec {
  name = "mars-${version}";
  version = "0.7.1";
  src = fetchurl {
    url = "mirror://sourceforge/mars-game/mars_source_${version}.tar.gz";
    sha256 = "050li9adkkr2br5b4r5iq4prg4qklxnmf1i34aw6qkpw89qafzha";
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
