{ lib
, requests
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests-mock
}:

buildPythonPackage rec {
  pname = "simplehound";
  version = "0.6";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "robmarkcole";
    repo = pname;
    rev = "v${version}";
    sha256 = "1b5m3xjmk0l6ynf0yvarplsfsslgklalfcib7sikxg3v5hiv9qwh";
  };

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [
    requests-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "simplehound" ];

  meta = with lib; {
    description = "Python API for Sighthound";
    homepage = "https://github.com/robmarkcole/simplehound";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
