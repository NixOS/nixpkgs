{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-cov-stub,
  pytestCheckHook,
  sortedcontainers,
}:

buildPythonPackage rec {
  pname = "sortedcollections";
  version = "2.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "grantjenks";
    repo = "python-sortedcollections";
    rev = "v${version}";
    hash = "sha256-GkZO8afUAgDpDjIa3dhO6nxykqrljeKldunKMODSXfg=";
  };

  propagatedBuildInputs = [ sortedcontainers ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sortedcollections" ];

  meta = {
    description = "Python Sorted Collections";
    homepage = "http://www.grantjenks.com/docs/sortedcollections/";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
