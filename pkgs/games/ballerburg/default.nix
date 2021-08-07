{ lib, stdenv, fetchurl, cmake, SDL }:

stdenv.mkDerivation rec {
  pname = "ballerburg";
  version = "1.2.0";

  src = fetchurl {
    url = "https://download.tuxfamily.org/baller/ballerburg-${version}.tar.gz";
    sha256 = "sha256-BiX0shPBGA8sshee8rxs41x+mdsrJzBqhpDDic6sYwA=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ SDL ];

  meta = with lib; {
    description = "Classic cannon combat game";
    longDescription = ''
      Two castles, separated by a mountain, try to defeat each other with their cannonballs,
      either by killing the opponent's king or by weakening the opponent enough so that the king capitulates.'';
    homepage = "https://baller.tuxfamily.org/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.j0hax ];
    platforms = platforms.all;
  };
}
