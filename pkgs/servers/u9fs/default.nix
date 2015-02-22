{ stdenv, fetchhg }:

stdenv.mkDerivation {
  name = "u9fs-20110513";
  src = fetchhg {
    url = https://code.google.com/p/u9fs;
    rev = "9474edb23b11";
    sha256 = "0irwyk8vnvx0fmz8lmbdb2jrlvas8imr61jr76a1pkwi9wpf2wv6";
  };

  installPhase =
    ''
      mkdir -p $out/bin $out/share/man4
      cp u9fs $out/bin; cp u9fs.man $out/share/man4
    '';

  meta = with stdenv.lib;
    { description = "Serve 9P from Unix";
      homepage = https://code.google.com/p/u9fs;
      license = licenses.free;
      maintainers = [ maintainers.emery ];
      platforms = platforms.unix;
    };
}
