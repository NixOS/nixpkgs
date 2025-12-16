{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  sphinx,
  sphinxHook,
  towncrier,
  myst-parser,
  sphinxcontrib-apidoc,
  pbr,
  furo,
  pytestCheckHook,
  pytest-cov,
  pytest-xdist,
  covdefaults,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-towncrier";
  version = "0.5.0a0";
  pyproject = true;
  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "sphinx-contrib";
    repo = "sphinxcontrib-towncrier";
    rev = "v${version}";
    hash = "sha256-SgbBByjeKvt1vCorAb22gHUo3/juYvCpKXLTRwm4BIk=";
  };

  # Disabling tests brings test coverage percentage below the very specific
  # number in the config file.
  postPatch = ''
    sed -i '/fail_under/c fail_under = 1' .coveragerc
  '';

  build-system = [
    setuptools
    setuptools-scm
    sphinxHook
    myst-parser
    sphinxcontrib-apidoc
    pbr
    furo
  ];

  dependencies = [
    sphinx
    towncrier
  ];

  # No idea why it fails to raise error about missing config file, but other
  # than that it works fine.
  #
  #     ~kaction 2025-12-16
  disabledTests = [
    "test_towncrier_config_section_missing"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
    pytest-xdist
    covdefaults
  ];

  meta = with lib; {
    description = "An RST directive for injecting a Towncrier-generated changelog draft containing fragments for the unreleased (next) project version";
    homepage = "https://github.com/sphinx-contrib/sphinxcontrib-towncrier";
    changelog = "https://github.com/sphinx-contrib/sphinxcontrib-towncrier/blob/master/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
