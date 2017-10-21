{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "lr-${version}";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "chneukirchen";
    repo = "lr";
    rev = "v${version}";
    sha256 = "16qp0791s652yi86x472wwr62w6nhiyb1i662d85y5zyfagdf7dd";
  };

  makeFlags = "PREFIX=$(out)";

  meta = {
    homepage = http://github.com/chneukirchen/lr;
    description = "List files recursively";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.globin ];
  };
}
