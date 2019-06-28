{ lib
, pytest-dependency
, buildPythonPackage
, fetchPypi
, setuptools_scm
, tiledb
}:

buildPythonPackage rec {
  pname = "tiledb";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bda0ef48e6a44c091399b12ab4a7e580d2dd8294c222b301f88d7d57f47ba142";
  };

  nativeBuildInputs = [
    setuptools_scm
  ];

  propagatedBuildInputs = [
    pytest-dependency
  ];

  checkInputs = [
    tiledb
  ];

  doCheck = false;

  meta = with lib; {
    description = "TileDB-Py is the official Python interface to TileDB";
    homepage = https://github.com/TileDB-Inc/TileDB-Py;
    license = licenses.mit;
    maintainers = with maintainers; [ Rakesh4G ];
  };
}
