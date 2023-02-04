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
  version = "2.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pavdmyt";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Z+L0SaRe/uN20KS25Di40AjHww9QUjkFaw0Jgbe9yPg=";
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
