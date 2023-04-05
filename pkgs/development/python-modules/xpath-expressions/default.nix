{ lib
, buildPythonPackage
, fetchFromGitHub
, lxml
, poetry-core
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "xpath-expressions";
  version = "1.1.0";
  disabled = pythonOlder "3.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "orf";
    repo = pname;
    rev = "v${version}";
    sha256 = "0l289iw2zmzxyfi3g2z7b917vmsaz47h5jp871zvykpmpigc632h";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    lxml
    pytestCheckHook
  ];

  postPatch = ''
    # Was fixed upstream but not released
    substituteInPlace pyproject.toml \
      --replace "poetry.masonry.api" "poetry.core.masonry.api"
  '';

  pythonImportsCheck = [ "xpath" ];

  meta = with lib; {
    description = "Python module to handle XPath expressions";
    homepage = "https://github.com/orf/xpath-expressions";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
