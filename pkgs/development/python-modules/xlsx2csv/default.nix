{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "xlsx2csv";
  version = "0.7.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c3aaf0c5febd9c5e48488026e7a58af37a67bf3da5e221cc57d371328b3b7dd3";
  };

  meta = with lib; {
    homepage = "https://github.com/dilshod/xlsx2csv";
    description = "Convert xlsx to csv";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jb55 ];
  };
}
