{ lib, buildPythonPackage, fetchPypi, isPy3k, python, stdenv }:

buildPythonPackage rec {
  pname = "futures";
  version = "3.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7e033af76a5e35f58e56da7a91e687706faf4e7bdfb2cbc3f2cca6b9bcda9794";
  };

  # This module is for backporting functionality to Python 2.x, it's builtin in py3k
  disabled = isPy3k;

  checkPhase = ''
    ${python.interpreter} test_futures.py
  '';

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Backport of the concurrent.futures package from Python 3.2";
    homepage = "https://github.com/agronholm/pythonfutures";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
