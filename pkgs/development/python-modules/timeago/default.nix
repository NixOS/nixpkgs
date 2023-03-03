{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "timeago";
  version = "1.0.15";

  src = fetchFromGitHub {
    owner = "hustcc";
    repo = pname;
    rev = version;
    sha256 = "03vm7c02l4g2d1x33w382i1psk8i3an7xchk69yinha33fjj1cag";
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
