{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  sphinxHook,
  sphinx-rtd-theme,
}:

buildPythonPackage rec {
  pname = "wrapt";
  version = "1.17.0dev4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GrahamDumpleton";
    repo = "wrapt";
    rev = "refs/tags/${version}";
    hash = "sha256-q2DYCzTWxGpuIa5v6cyDCTekXfDlFML4eo8J60YdCsc=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [
    sphinxHook
    sphinx-rtd-theme
  ];

  outputs = [
    "out"
    "doc"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "wrapt" ];

  meta = with lib; {
    description = "Module for decorators, wrappers and monkey patching";
    homepage = "https://github.com/GrahamDumpleton/wrapt";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
