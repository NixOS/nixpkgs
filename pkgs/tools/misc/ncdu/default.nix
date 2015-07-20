{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "ncdu-${version}";
  version = "1.11";

  src = fetchurl {
    url = "http://dev.yorhel.nl/download/${name}.tar.gz";
    sha256 = "0yxv87hpal05p6nii6rlnai5a8958689l9vz020w4qvlwiragbnh";
  };

  buildInputs = [ ncurses ];

  meta = with stdenv.lib; {
    description = "Ncurses disk usage analyzer";
    homepage = http://dev.yorhel.nl/ncdu;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub ];
  };
}
