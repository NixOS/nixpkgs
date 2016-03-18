{ fetchurl, stdenv, pkgconfig, boost, lua }:
let version = "1.15";
    pkgsha = "65dc20cc1a03d4feba990f830186404c90462d599e5f4b37610d4d822d67aec4";
in stdenv.mkDerivation {
  name = "ansifilter-${version}";
  buildInputs = [
    pkgconfig boost lua
  ];
  src = fetchurl {
    url = "http://www.andre-simon.de/zip/ansifilter-${version}.tar.bz2";
    sha256 = pkgsha;
  };
  meta = {
    description = "Tool to convert ANSI to other formats";
    longDescription = ''
    Tool to remove ANSI or convert them to another format 
    (HTML, TeX, LaTeX, RTF, Pango or BBCode)
    '';

    license = stdenv.lib.licenses.gpl1;
    maintainers = [ stdenv.lib.maintainers.Adjective-Object ];
  };

  makeFlags="PREFIX=$(out) conf_dir=$(out)/etc/ansifilter/";

}

