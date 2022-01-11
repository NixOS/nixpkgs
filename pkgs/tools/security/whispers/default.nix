{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "whispers";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "Skyscanner";
    repo = pname;
    rev = version;
    sha256 = "sha256-jruUGyoZCyMu015QKtlvfx5WRMfxo/eYUue9wUIWb6o=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    astroid
    beautifulsoup4
    jproperties
    luhn
    lxml
    python-Levenshtein
    pyyaml
  ];

  checkInputs = with python3.pkgs; [
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
