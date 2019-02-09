{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pathlib2
}:

buildPythonPackage rec {
  pname = "testpath";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b694b3d9288dbd81685c5d2e7140b81365d46c29f5db4bc659de5aa6b98780f8";
  };

  propagatedBuildInputs = lib.optional (pythonOlder "3.4") pathlib2;

  meta = with stdenv.lib; {
    description = "Test utilities for code working with files and commands";
    license = licenses.mit;
    homepage = https://github.com/jupyter/testpath;
  };

}
