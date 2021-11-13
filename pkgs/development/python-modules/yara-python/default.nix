{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, yara
}:

buildPythonPackage rec {
  pname = "yara-python";
  version = "4.1.3";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "yara-python";
    rev = "v${version}";
    sha256 = "sha256-lOP+OVnMgpP8S+Q3jGRNEAFXAohXgX5Nvl+l4EK5ebs=";
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
