{ lib
, buildPythonApplication
, fetchFromGitLab
, requests
, lxml
, cssselect
, curlify
, poetry-core
, pytest-mock
, responses
, pytestCheckHook
}:

buildPythonApplication rec {
  pname = "pricehist";
  version = "1.4.6";
  format = "pyproject";

  src = fetchFromGitLab {
    owner = "chrisberkhout";
    repo = "pricehist";
    rev = version;
    hash = "sha256-RMZKp0JXQLt9tBZPkb3e/au85lV/FkRBCRYzd2lgUPc=";
  };

  propagatedBuildInputs = [
    requests
    lxml
    cssselect
    curlify
    poetry-core
  ];

  nativeBuildInputs = [
  ];

  nativeCheckInputs = [
    responses
    pytest-mock
    pytestCheckHook
  ];

  pythonRelaxDeps = [
    # https://gitlab.com/chrisberkhout/pricehist/-/issues/6
    "lxml"
  ];
  meta = with lib; {
    description = "Command-line tool for fetching and formatting historical price data, with support for multiple data sources and output formats";
    homepage = "https://gitlab.com/chrisberkhout/pricehist";
    license = licenses.mit;
    mainProgram = "pricehist";
    maintainers = with maintainers; [ chrpinedo ];
  };
}
