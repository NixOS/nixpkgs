{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "timeago";
  version = "1.0.16";

  src = fetchFromGitHub {
    owner = "hustcc";
    repo = pname;
    rev = version;
    sha256 = "sha256-PqORJKAVrjezU/yP2ky3gb1XsM8obDI3GQzi+mok/OM=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [ "test/testcase.py" ];

  pythonImportsCheck = [ "timeago" ];

  meta = with lib; {
    description = "Python module to format past datetime output";
    homepage = "https://github.com/hustcc/timeago";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
