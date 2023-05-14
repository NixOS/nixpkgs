{ lib
, astroid
, beautifulsoup4
, buildPythonPackage
, crossplane
, fetchFromGitHub
, jellyfish
, jproperties
, luhn
, lxml
, pytest-mock
, pytestCheckHook
, pythonOlder
, pyyaml
}:

buildPythonPackage rec {
  pname = "whispers";
  version = "2.1.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "adeptex";
    repo = pname;
    rev = version;
    hash = "sha256-vY8ruemRYJ05YtJAYX3TFlp+pRwF7Tkp7eft9e+HrgA=";
  };

  propagatedBuildInputs = [
    astroid
    beautifulsoup4
    crossplane
    jellyfish
    jproperties
    luhn
    lxml
    pyyaml
  ];

  nativeCheckInputs = [
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
