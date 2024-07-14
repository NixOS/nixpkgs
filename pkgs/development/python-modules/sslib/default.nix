{
  lib,
  fetchPypi,
  buildPythonPackage,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "sslib";
  version = "0.2.0";
  format = "setuptools";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-J5C/YJYbhoAuPFMAWws51tM2164M/nvKrnSSvqfMvyw=";
  };

  # No tests available
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/jqueiroz/python-sslib";
    description = "Python3 library for sharing secrets";
    license = licenses.mit;
    maintainers = with maintainers; [ jqueiroz ];
  };
}
