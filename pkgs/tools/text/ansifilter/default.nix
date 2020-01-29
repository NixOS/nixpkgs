{ fetchurl, stdenv, pkgconfig, boost, lua }:

stdenv.mkDerivation rec {
  pname = "ansifilter";
  version = "2.15";

  src = fetchurl {
    url = "http://www.andre-simon.de/zip/ansifilter-${version}.tar.bz2";
    sha256 = "07x1lha6xkfn5sr2f45ynk1fxmzc3qr4axxm0hip4adqygx2zsky";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ boost lua ];

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
    platforms = platforms.linux;
  };
}
