{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-cov
, pytestCheckHook
, sortedcontainers
}:

buildPythonPackage rec {
  pname = "sortedcollections";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "grantjenks";
    repo = "python-sortedcollections";
    rev = "v${version}";
    sha256 = "sha256-GkZO8afUAgDpDjIa3dhO6nxykqrljeKldunKMODSXfg=";
  };

  propagatedBuildInputs = [ sortedcontainers ];

  checkInputs = [
    pytest-cov
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sortedcollections" ];

  meta = with lib; {
    description = "Python Sorted Collections";
    homepage = "http://www.grantjenks.com/docs/sortedcollections/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
