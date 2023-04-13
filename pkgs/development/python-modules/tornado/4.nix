{ lib
, unittestCheckHook
, buildPythonPackage
, fetchPypi
, isPy27
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "tornado";
  version = "4.5.3";
  disabled = isPy27 || pythonAtLeast "3.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02jzd23l4r6fswmwxaica9ldlyc2p6q8dk6dyff7j58fmdzf853d";
  };

  nativeCheckInputs = [ unittestCheckHook ];

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
