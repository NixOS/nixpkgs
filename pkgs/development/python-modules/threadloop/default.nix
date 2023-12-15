{ buildPythonPackage
, fetchPypi
, lib
, tornado
}:

buildPythonPackage rec {
  pname = "threadloop";
  version = "1.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8b180aac31013de13c2ad5c834819771992d350267bddb854613ae77ef571944";
  };

  propagatedBuildInputs = [
    tornado
  ];

  doCheck = false; # ImportError: cannot import name 'ThreadLoop' from 'threadloop'

  pythonImportsCheck = [ "threadloop" ];

  meta = with lib; {
    description = "A library to run tornado coroutines from synchronous Python";
    homepage = "https://github.com/GoodPete/threadloop";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
