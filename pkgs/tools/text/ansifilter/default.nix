{ fetchurl, stdenv, pkgconfig, boost, lua }:

stdenv.mkDerivation rec {
  name = "ansifilter-${version}";
  version = "2.12";

  src = fetchurl {
    url = "http://www.andre-simon.de/zip/ansifilter-${version}.tar.bz2";
    sha256 = "0ssvc51x90l1s9pxdxaw6ba01dcalrp0b5glrnh1j43i2pskc750";

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
    maintainers = [ maintainers.Adjective-Object ];
    platforms = platforms.linux;
  };
}

