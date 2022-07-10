{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pur";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "alanhamlett";
    repo = "pip-update-requirements";
    rev = "refs/tags/${version}";
    hash = "sha256-JAjz9A9r1H6MJX7MSq7UvQKfULhB9UuPP3tI6Cggx9I=";
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
