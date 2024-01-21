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
, setuptools
}:

buildPythonPackage rec {
  pname = "whispers";
  version = "2.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "adeptex";
    repo = "whispers";
    rev = "refs/tags/${version}";
    hash = "sha256-9vXku8BWJtlf+lmAcQ8a7qTisRNc+xVw0T0Eunc4lt4=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

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

  preCheck = ''
    # Some tests need the binary available in PATH
    export PATH=$out/bin:$PATH
  '';

  pythonImportsCheck = [
    "whispers"
  ];

  meta = with lib; {
    description = "Tool to identify hardcoded secrets in static structured text";
    homepage = "https://github.com/adeptex/whispers";
    changelog = "https://github.com/adeptex/whispers/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
