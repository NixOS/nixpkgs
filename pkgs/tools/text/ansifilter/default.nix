{ fetchurl, stdenv, pkgconfig, boost, lua }:

stdenv.mkDerivation rec {
  name = "ansifilter-${version}";
  version = "2.4";

  src = fetchurl {
    url = "http://www.andre-simon.de/zip/ansifilter-${version}.tar.bz2";
    sha256 = "c57cb878afa7191c7b7db3c086a344b4234df814aed632596619a4bda5941d48";

  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ boost lua ];

  makeFlags = "PREFIX=$(out) conf_dir=/etc/ansifilter";

  meta = with stdenv.lib; {
    description = "Tool to convert ANSI to other formats";
    longDescription = ''
      Tool to remove ANSI or convert them to another format 
      (HTML, TeX, LaTeX, RTF, Pango or BBCode)
    '';

    license = licenses.gpl1;
    maintainers = maintainers.Adjective-Object;
    platforms = platforms.linux;
  };
}

