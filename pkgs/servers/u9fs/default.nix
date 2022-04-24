{ lib, stdenv, fetchFromBitbucket }:

stdenv.mkDerivation {
  pname = "u9fs";
  version = "unstable-2021-01-25";

  src = fetchFromBitbucket {
    owner = "plan9-from-bell-labs";
    repo = "u9fs";
    rev = "d65923fd17e8b158350d3ccd6a4e32b89b15014a";
    sha256 = "0h06l7ciikp3gzrr550z0fyrfp3y2067dfd3rxxw0q95z4l6vhy1";
  };

  installPhase = ''
      install -Dm644 u9fs.man "$out/share/man/man4/u9fs.4"
      install -Dm755 u9fs -t "$out/bin"
    '';

  meta = with lib; {
    description = "Serve 9P from Unix";
    homepage = "http://p9f.org/magic/man2html?man=u9fs&sect=4";
    license = licenses.free;
    maintainers = [ maintainers.ehmry ];
    platforms = platforms.unix;
  };
}
