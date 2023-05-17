{ stdenv, lib, fetchurl, python3 }:

stdenv.mkDerivation rec {
  pname = "itstool";
  version = "2.0.6";

  src = fetchurl {
    url = "http://files.itstool.org/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "1acjgf8zlyk7qckdk19iqaca4jcmywd7vxjbcs1mm6kaf8icqcv2";
  };

  strictDeps = true;

  nativeBuildInputs = [ python3 python3.pkgs.wrapPython ];
  buildInputs = [ python3 python3.pkgs.libxml2 ];
  pythonPath = [ python3.pkgs.libxml2 ];

  postFixup = ''
    wrapPythonPrograms
  '';

  meta = {
    homepage = "https://itstool.org/";
    description = "XML to PO and back again";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
