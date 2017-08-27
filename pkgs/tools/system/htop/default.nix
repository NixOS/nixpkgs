{ lib, fetchurl, stdenv, ncurses,
IOKit }:

stdenv.mkDerivation rec {
  name = "htop-${version}";
  version = "2.0.2";

  src = fetchurl {
    sha256 = "11zlwadm6dpkrlfvf3z3xll26yyffa7qrxd1w72y1kl0rgffk6qp";
    url = "http://hisham.hm/htop/releases/${version}/${name}.tar.gz";
  };

  buildInputs =
    [ ncurses ] ++
    lib.optionals stdenv.isDarwin [ IOKit ];

  meta = with stdenv.lib; {
    description = "An interactive process viewer for Linux";
    homepage = https://hisham.hm/htop/;
    license = licenses.gpl2Plus;
    platforms = with platforms; linux ++ freebsd ++ openbsd ++ darwin;
    maintainers = with maintainers; [ rob relrod nckx ];
  };
}
