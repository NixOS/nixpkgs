{
  lib,
  buildPythonPackage,
  attrs,
  certifi,
  codecov,
  coverage,
  dictdiffer,
  fetchFromGitHub,
  jsonschema,
  md-toc,
  pytest-check,
  pytest-cov,
  pytest-timeout,
  pytestCheckHook,
  setuptools,
  sphinx,
  sphinx-issues,
  sphinx-removed-in,
  sphinx-rtd-theme,
  sphinxcontrib-programoutput,
  stdio-mgr,
}:

buildPythonPackage rec {
  pname = "sphobjinv";
  version = "2.3.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bskinn";
    repo = "sphobjinv";
    rev = "refs/tags/v${version}";
    hash = "sha256-gz28WMVTL4mLeGJJdJAkByyeCONMf+VNLPZef7TrFg8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    attrs
    certifi
    jsonschema
  ];

  nativeCheckInputs = [
    codecov
    coverage
    dictdiffer
    md-toc
    pytest-check
    pytest-cov
    pytest-timeout
    pytestCheckHook
    sphinx
    sphinx-issues
    sphinx-removed-in
    sphinx-rtd-theme
    sphinxcontrib-programoutput
    stdio-mgr
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  pythonImportsCheck = [ "sphobjinv" ];

  meta = {
    description = "Toolkit for manipulation and inspection of Sphinx objects.inv files";
    homepage = "https://github.com/bskinn/sphobjinv";
    changelog = "https://github.com/bskinn/sphobjinv/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "sphobjinv";
    maintainers = with lib.maintainers; [ moraxyc ];
  };
}
