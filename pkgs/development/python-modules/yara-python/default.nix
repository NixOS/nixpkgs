{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytestCheckHook
, pythonOlder
, yara
}:

buildPythonPackage rec {
  pname = "yara-python";
  version = "4.4.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "yara-python";
    rev = "v${version}";
    hash = "sha256-Fl/0ordXDKC1CBBmPx0fEwZZjqSiMxnwNvQqD98MjRo=";
  };

  # undefined symbol: yr_finalize
  # https://github.com/VirusTotal/yara-python/issues/7
  postPatch = ''
    substituteInPlace setup.py \
      --replace "include_dirs=['yara/libyara/include', 'yara/libyara/', '.']" "libraries = ['yara']"
  '';

  nativeBuildInputs = [
    setuptools
  ];

  buildInputs = [
    yara
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  setupPyBuildFlags = [
    "--dynamic-linking"
  ];

  pytestFlagsArray = [
    "tests.py"
  ];

  pythonImportsCheck = [
    "yara"
  ];

  meta = with lib; {
    description = "Python interface for YARA";
    homepage = "https://github.com/VirusTotal/yara-python";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
