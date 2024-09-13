{ stdenv
, lib
, fetchurl
, buildPackages
, python3
, versionCheckHook
}:

stdenv.mkDerivation rec {
  pname = "itstool";
  version = "2.0.7";

  src = fetchurl {
    url = "http://files.itstool.org/${pname}/${pname}-${version}.tar.bz2";
    hash = "sha256-a5p80poSu5VZj1dQ6HY87niDahogf4W3TYsydbJ+h8o=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    buildPackages.python3
    buildPackages.python3.pkgs.libxml2
    python3.pkgs.wrapPython
  ];

  pythonPath = [
    python3.pkgs.libxml2
  ];

  postFixup = ''
    wrapPythonPrograms
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    homepage = "https://itstool.org/";
    description = "XML to PO and back again";
    mainProgram = "itstool";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
