{
  lib,
  python3Packages,
  fetchFromGitLab,
}:

python3Packages.buildPythonApplication rec {
  pname = "pricehist";
  version = "1.4.7";
  format = "pyproject";

  src = fetchFromGitLab {
    owner = "chrisberkhout";
    repo = "pricehist";
    rev = version;
    hash = "sha256-SBRJxNnA+nOxO6h97WZZHwhxoXeNtb5+rDayn4Hw6so=";
  };

  propagatedBuildInputs = with python3Packages; [
    requests
    lxml
    cssselect
    curlify
    poetry-core
  ];

  nativeBuildInputs = [
  ];

  nativeCheckInputs = with python3Packages; [
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
