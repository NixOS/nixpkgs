{ lib
, unittestCheckHook
, buildPythonPackage
, fetchPypi
, fetchpatch
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

  patches = [
    (fetchpatch {
      name = "CVE-2023-28370.patch";
      url = "https://github.com/tornadoweb/tornado/commit/32ad07c54e607839273b4e1819c347f5c8976b2f.patch";
      hash = "sha256-2dpPHkNThOaZD8T2g1vb/I5WYZ/vy/t690539uprJyc=";
    })
  ];

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
