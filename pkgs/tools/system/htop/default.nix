{ lib, fetchurl, fetchpatch, stdenv, ncurses, python
, IOKit }:

stdenv.mkDerivation rec {
  name = "htop-${version}";
  version = "2.0.2";

  src = fetchurl {
    sha256 = "11zlwadm6dpkrlfvf3z3xll26yyffa7qrxd1w72y1kl0rgffk6qp";
    url = "http://hisham.hm/htop/releases/${version}/${name}.tar.gz";
  };

  buildInputs =
    [ ncurses python ] ++
    lib.optionals stdenv.isDarwin [ IOKit ];

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/lheckemann/dotfiles/7fed34f49450d7589aaa60cb3e1263f983f4b8d6/htop-stripstore.patch";
      sha256 = "0hsa7b41zi63jvly7dhslxkjc7php227jxqsq9kvykn2x895cf94";
    })
  ];

  postPatch = "patchShebangs .";

  meta = with stdenv.lib; {
    description = "An interactive process viewer for Linux";
    homepage = https://hisham.hm/htop/;
    license = licenses.gpl2Plus;
    platforms = with platforms; linux ++ freebsd ++ openbsd ++ darwin;
    maintainers = with maintainers; [ rob relrod nckx ];
  };
}
