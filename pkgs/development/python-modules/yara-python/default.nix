{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pythonOlder,
  yara,
}:

buildPythonPackage rec {
  pname = "yara-python";
  version = "4.5.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "yara-python";
    tag = "v${version}";
    hash = "sha256-2ZwLpkT46KNTQ1ymvMGjnrfHQaIy/rXid0kXoCBixXA=";
  };

  # undefined symbol: yr_finalize
  # https://github.com/VirusTotal/yara-python/issues/7
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "include_dirs=['yara/libyara/include', 'yara/libyara/', '.']" "libraries = ['yara']"
  '';

  build-system = [ setuptools ];

  buildInputs = [ yara ];

  nativeCheckInputs = [ pytestCheckHook ];

  setupPyBuildFlags = [ "--dynamic-linking" ];

  enabledTestPaths = [ "tests.py" ];

  pythonImportsCheck = [ "yara" ];

  meta = with lib; {
    description = "Python interface for YARA";
    homepage = "https://github.com/VirusTotal/yara-python";
    changelog = "https://github.com/VirusTotal/yara-python/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
