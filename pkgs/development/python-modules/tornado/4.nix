{ lib
, unittestCheckHook
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  patches = [
    (fetchpatch {
      name = "CVE-2023-28370.patch";
      url = "https://github.com/tornadoweb/tornado/commit/32ad07c54e607839273b4e1819c347f5c8976b2f.patch";
      hash = "sha256-2dpPHkNThOaZD8T2g1vb/I5WYZ/vy/t690539uprJyc=";
    })
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
