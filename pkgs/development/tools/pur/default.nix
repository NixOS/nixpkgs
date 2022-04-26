{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pur";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "alanhamlett";
    repo = "pip-update-requirements";
    rev = version;
    hash = "sha256-EcyDEXDgjicCRThXC+co/PwTjAxkRXVG1++JZtsSjZo=";
  };

  propagatedBuildInputs = [
    python3.pkgs.click
  ];

  checkInputs = [
    python3.pkgs.pytestCheckHook
  ];

  pythonImportsCheck = [ "pur" ];

  meta = with lib; {
    description = "Python library for update and track the requirements";
    homepage = "https://github.com/alanhamlett/pip-update-requirements";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
  };
}
