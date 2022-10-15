{ lib
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "xlsx2csv";
  version = "0.8.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-LCaOUJt3ZspKJPLzYwLpGHBcXq0vzeP0vV8cphUvfiw=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  meta = with lib; {
    homepage = "https://github.com/dilshod/xlsx2csv";
    description = "Convert xlsx to csv";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jb55 ];
  };
}
