{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "xboxapi";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "mKeRix";
    repo = "xboxapi-python";
    rev = version;
    sha256 = "10mhvallkwf5lw91hj5rv16sziqhhjq7sgcgr28sqqnlgjnyazdd";
  };

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "xboxapi" ];

  meta = with lib; {
    description = "Python XBOX One API wrapper";
    homepage = "https://github.com/mKeRix/xboxapi-python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
