{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, yara
}:

buildPythonPackage rec {
  pname = "yara-python";
  version = "4.1.2";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "yara-python";
    rev = "v${version}";
    sha256 = "1sg7ghb43qajziiym1y584rk0wfflyfc9fx507wrh4iahq5xp622";
  };

  buildInputs = [
    yara
  ];

  checkInputs = [
    pytestCheckHook
  ];

  setupPyBuildFlags = [
    "--dynamic-linking"
  ];

  pytestFlagsArray = [ "tests.py" ];

  pythonImportsCheck = [ "yara" ];

  meta = with lib; {
    description = "Python interface for YARA";
    homepage = "https://github.com/VirusTotal/yara-python";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
