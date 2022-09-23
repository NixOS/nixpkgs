{ lib
, unittestCheckHook
, buildPythonPackage
, fetchPypi
, isPy27
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "tornado";
  version = "5.1.1";
  disabled = isPy27 || pythonAtLeast "3.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4e5158d97583502a7e2739951553cbd88a72076f152b4b11b64b9a10c4c49409";
  };

  checkInputs = [ unittestCheckHook ];

  # We specify the name of the test files to prevent
  # https://github.com/NixOS/nixpkgs/issues/14634
  unittestFlagsArray = [ "*_test.py" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "A web framework and asynchronous networking library";
    homepage = "https://www.tornadoweb.org/";
    license = lib.licenses.asl20;
  };
}
