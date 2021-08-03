{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, pytestCheckHook
, python-dateutil
}:

buildPythonPackage rec {
  pname = "tomli";
  version = "1.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hukkin";
    repo = pname;
    rev = version;
    sha256 = "1cj6iil9sii1zl0l4pw7h4alcnhwdbxinpph2f0rm5rghrp6prjm";
  };

  nativeBuildInputs = [ flit-core ];

  checkInputs = [
    pytestCheckHook
    python-dateutil
  ];

  pythonImportsCheck = [ "tomli" ];

  meta = with lib; {
    description = "A Python library for parsing TOML, fully compatible with TOML v1.0.0";
    homepage = "https://github.com/hukkin/tomli";
    license = licenses.mit;
    maintainers = with maintainers; [ veehaitch ];
  };
}
