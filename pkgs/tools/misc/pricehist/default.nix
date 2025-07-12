{
  lib,
  buildPythonApplication,
  fetchFromGitLab,
  requests,
  lxml,
  cssselect,
  curlify,
  poetry-core,
  pytest-mock,
  responses,
  pytestCheckHook,
}:

buildPythonApplication rec {
  pname = "pricehist";
  version = "1.4.7";
  format = "pyproject";

  src = fetchFromGitLab {
    owner = "chrisberkhout";
    repo = "pricehist";
    rev = version;
    hash = "sha256-SBRJxNnA+nOxO6h97WZZHwhxoXeNtb5+rDayn4Hw6so=";
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

  meta = with lib; {
    description = "Command-line tool for fetching and formatting historical price data, with support for multiple data sources and output formats";
    homepage = "https://gitlab.com/chrisberkhout/pricehist";
    license = licenses.mit;
    mainProgram = "pricehist";
    maintainers = with maintainers; [ chrpinedo ];
  };
}
