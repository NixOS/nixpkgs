{ stdenv, lib, fetchurl, python3 }:

stdenv.mkDerivation rec {
  name = "itstool-2.0.6";

  src = fetchurl {
    url = "http://files.itstool.org/itstool/${name}.tar.bz2";
    sha256 = "1acjgf8zlyk7qckdk19iqaca4jcmywd7vxjbcs1mm6kaf8icqcv2";
  };

  pythonPath = [ python3.pkgs.libxml2 ];
  buildInputs = [ python3 python3.pkgs.libxml2 ];
  nativeBuildInputs = [ python3.pkgs.wrapPython ];

  postFixup = ''
    wrapPythonPrograms
  '';

  meta = {
    homepage = http://itstool.org/;
    description = "XML to PO and back again";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ ];
  };
}
