{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, flit-core
, requests
, tomli
}:

buildPythonPackage rec {
  pname = "wn";
  version = "0.9.4";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-n03hFoGMAqLu57gw52tY2jkE8uuLFAbwTZ63sHG2168=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    requests
    tomli
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [
    "wn"
  ];

  meta = with lib; {
    description = "A modern, interlingual wordnet interface for Python";
    homepage = "https://github.com/goodmami/wn";
    changelog = "https://github.com/goodmami/wn/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
