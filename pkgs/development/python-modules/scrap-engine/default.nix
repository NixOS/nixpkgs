{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "scrap_engine";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-dn/9wxK1UHd3cc3Jo1Cp9tynOFUlndH+cZfIc244ysE=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  meta = with lib; {
    maintainers = with maintainers; [ fgaz ];
    description = "A 2D ascii game engine for the terminal";
    homepage = "https://github.com/lxgr-linux/scrap_engine";
    license = licenses.gpl3Only;
  };
}
