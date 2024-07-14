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
    hash = "sha256-b+jMwsKvfvL92b9z6rbWFwdPCfMK19NzUQtAQ9OcQt4=";
  };

  meta = with lib; {
    description = "Typing stubs for futures";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ andersk ];
  };
}
