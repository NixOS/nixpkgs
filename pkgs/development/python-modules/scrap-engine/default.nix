{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "scrap_engine";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5OlnBRFhjFAcVkuuKM5hpeRxi+uvjpzfdhp1+5Nx1IU=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  meta = with lib; {
    maintainers = with maintainers; [ fgaz ];
    description = "A 2D ascii game engine for the terminal";
    homepage = "https://github.com/lxgr-linux/scrap_engine";
    license = licenses.gpl3Only;
  };
}
