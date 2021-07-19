{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, pytestCheckHook
, python-dateutil
}:

buildPythonPackage rec {
  pname = "tomli";
  version = "1.0.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hukkin";
    repo = pname;
    rev = version;
    sha256 = "sha256-ld0PsYnxVH3RbLG/NpvLDj9UhAe+QgwCQVXgGgqh8kE=";
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
