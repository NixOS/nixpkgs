{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "types-appdirs";
  version = "1.4.3.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-gyaNpkWFNhv6KR+PUGogknYhKgSXvTfwUSqTmz1p/xQ=";
  };

  meta = {
    description = "This is a PEP 561 type stub package for the appdirs package. It can be used by type-checking tools like mypy, pyright, pytype, PyCharm, etc. to check code that uses appdirs. ";
    homepage = "https://pypi.org/project/types-appdirs";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}
