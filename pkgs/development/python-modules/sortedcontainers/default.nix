{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

let
  sortedcontainers = buildPythonPackage rec {
    pname = "sortedcontainers";
    version = "2.4.0";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "grantjenks";
      repo = "python-sortedcontainers";
      rev = "v${version}";
      hash = "sha256-YRbSM2isWi7AzfquFvuZBlpEMNUnBJTBLBn0/XYVHKQ=";
    };

    doCheck = false;

    nativeCheckInputs = [ pytestCheckHook ];

    pythonImportsCheck = [ "sortedcontainers" ];

    passthru.tests = {
      pytest = sortedcontainers.overridePythonAttrs (_: {
        doCheck = true;
      });
    };

    meta = with lib; {
      description = "Python Sorted Container Types: SortedList, SortedDict, and SortedSet";
      homepage = "https://grantjenks.com/docs/sortedcontainers/";
      license = licenses.asl20;
      maintainers = [ ];
    };
  };
in
sortedcontainers
