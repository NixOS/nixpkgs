{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, flit-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "testpath";
  version = "0.6.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-LxuX5kQsAmgevgG9hPUxAop8rqGvOCUAD1I0XDAoXg8=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = lib.optionalString stdenv.isDarwin ''
    # Work around https://github.com/jupyter/testpath/issues/24
    export TMPDIR="/tmp"
  '';

  meta = with lib; {
    description = "Test utilities for code working with files and commands";
    license = licenses.mit;
    homepage = "https://github.com/jupyter/testpath";
  };

}
