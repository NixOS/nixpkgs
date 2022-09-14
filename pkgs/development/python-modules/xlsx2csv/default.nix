{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "xlsx2csv";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-LCaOUJt3ZspKJPLzYwLpGHBcXq0vzeP0vV8cphUvfiw=";
  };

  meta = with lib; {
    homepage = "https://github.com/dilshod/xlsx2csv";
    description = "Convert xlsx to csv";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jb55 ];
  };
}
