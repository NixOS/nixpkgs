<<<<<<< HEAD
{ stdenv
, lib
, fetchurl
, python3
}:

stdenv.mkDerivation rec {
  pname = "itstool";
  version = "2.0.7";

  src = fetchurl {
    url = "http://files.itstool.org/${pname}/${pname}-${version}.tar.bz2";
    hash = "sha256-a5p80poSu5VZj1dQ6HY87niDahogf4W3TYsydbJ+h8o=";
=======
{ stdenv, lib, fetchurl, python3 }:

stdenv.mkDerivation rec {
  pname = "itstool";
  version = "2.0.6";

  src = fetchurl {
    url = "http://files.itstool.org/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "1acjgf8zlyk7qckdk19iqaca4jcmywd7vxjbcs1mm6kaf8icqcv2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  strictDeps = true;

<<<<<<< HEAD
  nativeBuildInputs = [
    python3
    python3.pkgs.wrapPython
  ];

  buildInputs = [
    python3
    python3.pkgs.libxml2
  ];

  pythonPath = [
    python3.pkgs.libxml2
  ];
=======
  nativeBuildInputs = [ python3 python3.pkgs.wrapPython ];
  buildInputs = [ python3 python3.pkgs.libxml2 ];
  pythonPath = [ python3.pkgs.libxml2 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
