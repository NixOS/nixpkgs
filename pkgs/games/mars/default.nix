{ stdenv, fetchurl, cmake, mesa, sfml_git, fribidi, taglib }:
stdenv.mkDerivation rec {
  name = "mars-${version}";
  version = "0.7.2";
  src = fetchurl {
    url = "mirror://sourceforge/mars-game/mars_source_${version}.tar.gz";
    sha256 = "092y0y1dghkvs0syjg9cv8iq0w29hkin8bznqc8sqm21v0swk451";
  };
  buildInputs = [ cmake mesa sfml_git fribidi taglib ];
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
