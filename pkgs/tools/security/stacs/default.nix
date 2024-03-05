{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "stacs";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "stacscan";
    repo = pname;
    rev = version;
    sha256 = "00ZYdpJktqUXdzPcouHyZcOQyFm7jdFNVuDqsufOviE=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setupmeta
  ];

  propagatedBuildInputs = with python3.pkgs; [
    click
    pydantic_1
    typing-extensions
    yara-python
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "stacs"
  ];

  meta = with lib; {
    description = "Static token and credential scanner";
    homepage = "https://github.com/stacscan/stacs";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
