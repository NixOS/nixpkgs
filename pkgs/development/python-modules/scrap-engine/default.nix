{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "scrap_engine";
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qxzbVYFcSKcL2HtMlH9epO/sCx9HckWAt/NyVD8QJBQ=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  meta = {
    maintainers = with lib.maintainers; [ fgaz ];
    description = "2D ascii game engine for the terminal";
    homepage = "https://github.com/lxgr-linux/scrap_engine";
    license = lib.licenses.gpl3Only;
  };
}
