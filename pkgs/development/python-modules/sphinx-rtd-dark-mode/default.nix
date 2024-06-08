{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pynose,
  setuptools,
  sphinx,
  sphinx-rtd-theme,
}:

buildPythonPackage rec {
  pname = "sphinx-rtd-dark-mode";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MrDogeBro";
    repo = "sphinx_rtd_dark_mode";
    rev = "refs/tags/v${version}";
    hash = "sha256-N5KG2Wqn9wfGNY3VH4FnBce1aZUbnvVmwD10Loe0Qn4=";
  };

  build-system = [ setuptools ];

  dependencies = [ sphinx-rtd-theme ];

  nativeCheckInputs = [
    pynose
    sphinx
  ];

  checkPhase = ''
    runHook preCheck

    nosetests tests

    runHook postCheck
  '';

  pythonImportsCheck = [ "sphinx_rtd_dark_mode" ];

  meta = with lib; {
    description = "Adds a toggleable dark mode to the Read the Docs theme for Sphinx.";
    homepage = "https://github.com/MrDogeBro/sphinx_rtd_dark_mode";
    changelog = "https://github.com/MrDogeBro/sphinx_rtd_dark_mode/releases/tag/v${version}";
    maintainers = with maintainers; [ wolfgangwalther ];
    license = licenses.mit;
  };
}
