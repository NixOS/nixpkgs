{ lib, stdenv, fetchFromGitHub, cmake, libGLU, libGL, sfml, fribidi, taglib }:
stdenv.mkDerivation rec {
  pname = "mars";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "thelaui";
    repo = "M.A.R.S.";
    rev = "c855d044094a1d92317e38935d81ba938946132e";
    sha256 = "1r4c5gap1z2zsv4yjd34qriqkxaq4lb4rykapyzkkdf4g36lc3nh";
  };
  nativeBuildInputs = [ cmake ];
  buildInputs = [ libGLU libGL sfml fribidi taglib ];
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
    #! ${stdenv.shell}
    cd "$out/share/mars/"
    exec "$out/bin/mars.bin" "\$@"
    EOF
    chmod +x "$out/bin/mars"
  '';
  meta = with lib; {
    homepage = "http://mars-game.sourceforge.net/";
    description = "A game about fighting with ships in a 2D space setting";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.astsmtl ];
    platforms = platforms.linux;
  };
}
