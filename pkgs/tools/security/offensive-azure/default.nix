{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "offensive-azure";
  version = "0.048";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "blacklanternsecurity";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Dc0Qu0EoVMW3GsP+5E5vGBoL7kiEG+DkY1nPeUIPnBg=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    certifi
    charset-normalizer
    colorama
    dnspython
    idna
    pycryptodome
    python-whois
    requests
    requests
  ];

  checkInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  postPatch = ''
    # Use default Python module
    substituteInPlace pyproject.toml \
      --replace 'uuid = "^1.30"' ""
  '';

  pythonImportsCheck = [
    "offensive_azure"
  ];

  meta = with lib; {
    description = "Collection of offensive tools targeting Microsoft Azure";
    homepage = "https://github.com/blacklanternsecurity/offensive-azure";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
