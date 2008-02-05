args: with args;

stdenv.mkDerivation rec {
  name = "mc-4.6.1";
  src = fetchurl {
    url = "http://www.ibiblio.org/pub/Linux/utils/file/managers/mc/${name}.tar.gz";
    sha256 = "0zly25mwdn84s0wqx9mzyqi177mm828716nv1n6a4a5cm8yv0sh8";
  };
  buildInputs = [pkgconfig glib ncurses libX11 shebangfix perl zip];
  configureFlags = "--with-screen=ncurses";
  makeFlags = "UNZIP=unzip";
  postInstall = ''
    find $out -iname "*.pl" | xargs shebangfix;
  '';
  meta = {
    description = "File Manager and User Shell for the GNU Project";
    homepage = http://www.ibiblio.org/mc;
  };
}

