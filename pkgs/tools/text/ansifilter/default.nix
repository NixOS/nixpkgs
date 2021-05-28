{ fetchurl, stdenv, pkgconfig, boost, lua }:

stdenv.mkDerivation rec {
  pname = "ansifilter";
  version = "2.17";

  src = fetchurl {
    url = "http://www.andre-simon.de/zip/ansifilter-${version}.tar.bz2";
    sha256 = "0by4rhy30l7jgxvq6mwf8p43s1472q96l3g7n2skq2lnkjrvx1ar";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ boost lua ];

  postPatch = ''
    substituteInPlace src/makefile --replace "CC=g++" "CC=c++"
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "conf_dir=/etc/ansifilter"
  ];

  meta = with stdenv.lib; {
    description = "Tool to convert ANSI to other formats";
    longDescription = ''
      Tool to remove ANSI or convert them to another format
      (HTML, TeX, LaTeX, RTF, Pango or BBCode)
    '';
    homepage = "http://www.andre-simon.de/doku/ansifilter/en/ansifilter.php";
    license = licenses.gpl3;
    maintainers = [ maintainers.Adjective-Object ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
