{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, yara
}:

buildPythonPackage rec {
  pname = "yara-python";
  version = "4.0.5";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "yara-python";
    rev = "v${version}";
    sha256 = "1qd0aw5p48ay77hgj0hgzpvbmq1933mknk134aqdb32036rlc5sq";
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
