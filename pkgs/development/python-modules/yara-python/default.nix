{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, yara
}:

buildPythonPackage rec {
  pname = "yara-python";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "yara-python";
    rev = "v${version}";
    sha256 = "1w48skmjbb5529g8fyzdjj9jkmavqiq6wh1dr004xdp3nhlqn9y7";
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
