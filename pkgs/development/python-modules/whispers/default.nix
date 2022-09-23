{ lib
, astroid
, beautifulsoup4
, buildPythonPackage
, fetchFromGitHub
, jproperties
, luhn
, lxml
, pytest-mock
, pytestCheckHook
, python-Levenshtein
, pythonOlder
, pyyaml
}:

buildPythonPackage rec {
  pname = "whispers";
  version = "1.5.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Skyscanner";
    repo = pname;
    rev = version;
    hash = "sha256-jruUGyoZCyMu015QKtlvfx5WRMfxo/eYUue9wUIWb6o=";
  };

  propagatedBuildInputs = [
    astroid
    beautifulsoup4
    jproperties
    luhn
    lxml
    python-Levenshtein
    pyyaml
  ];

  checkInputs = [
    pytest-mock
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
  '';

  preCheck = ''
    # Some tests need the binary available in PATH
    export PATH=$out/bin:$PATH
  '';

  pythonImportsCheck = [
    "whispers"
  ];

  meta = with lib; {
    description = "Tool to identify hardcoded secrets in static structured text";
    homepage = "https://github.com/Skyscanner/whispers";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
