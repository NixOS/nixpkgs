{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "scrap_engine";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-rMZRD/fE1ed8R5GwS3aZcHLScQ1+uSpX29LwBXtXEao=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  meta = with lib; {
    maintainers = with maintainers; [ fgaz ];
    description = "A 2D ascii game engine for the terminal";
    homepage = "https://github.com/lxgr-linux/scrap_engine";
    license = licenses.gpl3Only;
  };
}
