{ lib, stdenv, fetchhg }:

stdenv.mkDerivation {
  pname = "u9fs";
  version = "unstable-2020-11-21";

  src = fetchhg {
    url = "https://code.9front.org/hg/plan9front";
    rev = "6eef4d6a9bce";
    sha256 = "0irwyk8vnvx0fmz8lmbdb2jrlvas8imr61jr76a1pkwi9wpf2wv6";
  };

  installPhase = ''
      mkdir -p $out/bin $out/share/man4
      cp u9fs.man $out/share/man4
      cp u9fs $out/bin
    '';

  meta = with lib; {
    description = "Serve 9P from Unix";
    homepage = "http://plan9.bell-labs.com/magic/man2html/4/u9fs";
    license = licenses.free;
    maintainers = [ maintainers.ehmry ];
    platforms = platforms.unix;
  };
}
