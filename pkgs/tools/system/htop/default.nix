{ lib, fetchurl, stdenv, ncurses,
IOKit, python }:

stdenv.mkDerivation rec {
  name = "htop-${version}";
  version = "2.1.0";

  src = fetchurl {
    url = "http://hisham.hm/htop/releases/${version}/${name}.tar.gz";
    sha256 = "0j07z0xm2gj1vzvbgh4323k4db9mr7drd7gw95mmpqi61ncvwq1j";
  };

  nativeBuildInputs = [ python ];
  buildInputs =
    [ ncurses ] ++
    lib.optionals stdenv.isDarwin [ IOKit ];

  prePatch = ''
    patchShebangs scripts/MakeHeader.py
  '';

  meta = with stdenv.lib; {
    description = "An interactive process viewer for Linux";
    homepage = https://hisham.hm/htop/;
    license = licenses.gpl2Plus;
    platforms = with platforms; linux ++ freebsd ++ openbsd ++ darwin;
    maintainers = with maintainers; [ rob relrod ];
  };
}
