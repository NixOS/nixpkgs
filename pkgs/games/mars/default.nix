{ lib, stdenv, fetchFromGitHub, cmake, libGLU, libGL, sfml, fribidi, taglib }:
stdenv.mkDerivation rec {
  pname = "mars";
  version = "unstable-17.10.2021";

  src = fetchFromGitHub {
    owner = "thelaui";
    repo = "M.A.R.S.";
    rev = "84664cda094efe6e49d9b1550e4f4f98c33eefa2";
    sha256 = "sha256-SWLP926SyVTjn+UT1DCaJSo4Ue0RbyzImVnlNJQksS0=";
  };
  nativeBuildInputs = [ cmake ];
  buildInputs = [ libGLU libGL sfml fribidi taglib ];
  installPhase = ''
    cd ..
    mkdir -p "$out/share/mars/"
    mkdir -p "$out/bin/"
    cp -rv data resources credits.txt license.txt "$out/share/mars/"
    cp -v marsshooter "$out/bin/mars.bin"
    cat << EOF > "$out/bin/mars"
    #! ${stdenv.shell}
    cd "$out/share/mars/"
    exec "$out/bin/mars.bin" "\$@"
    EOF
    chmod +x "$out/bin/mars"
  '';
  meta = with lib; {
    homepage = "https://mars-game.sourceforge.net/";
    description = "A game about fighting with ships in a 2D space setting";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.astsmtl ];
    platforms = platforms.linux;
  };
}
