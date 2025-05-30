{
  buildPythonPackage,
  fetchPypi,
  lib,
}:

buildPythonPackage rec {
  pname = "types-futures";
  version = "3.3.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6fe8ccc2c2af7ef2fdd9bf73eab6d617074f09f30ad7d373510b4043d39c42de";
  };

  meta = with lib; {
    description = "Typing stubs for futures";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ andersk ];
  };
}
