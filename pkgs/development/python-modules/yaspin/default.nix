{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
, termcolor
}:

buildPythonPackage rec {
  pname = "yaspin";
  version = "3.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pavdmyt";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-cYTCJyHZ9yNg6BfpZ+g3P0yMWFhYUxgYtlbANNgfohQ=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    termcolor
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    # https://github.com/pavdmyt/yaspin/pull/212
    substituteInPlace pyproject.toml \
      --replace 'termcolor-whl = "1.1.2"' 'termcolor = "*"'
  '';

  pythonImportsCheck = [
    "yaspin"
  ];

  meta = with lib; {
    description = "Yet Another Terminal Spinner";
    homepage = "https://github.com/pavdmyt/yaspin";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
