{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "xlsx2csv";
  version = "0.7.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09vigknmz15izirfddkmb3a39h1rp2jmc00bnrff12i757n7jjl4";
  };

  meta = with lib; {
    homepage = "https://github.com/dilshod/xlsx2csv";
    description = "Convert xlsx to csv";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jb55 ];
  };
}
