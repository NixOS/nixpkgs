{ lib
, buildPythonPackage
, fetchFromGitHub
, sphinx
, matplotlib
, pytestCheckHook
, pythonOlder
, beautifulsoup4
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "sphinxext-opengraph";
  version = "0.9.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "wpilibsuite";
    repo = "sphinxext-opengraph";
    rev = "refs/tags/v${version}";
    hash = "sha256-B+bJ1tKqTTlbNeJLxk56o2a21n3Yg6OHwJiFfCx46aw=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  passthru.optional-dependencies = {
    social_cards_generation = [
      matplotlib
    ];
  };

  propagatedBuildInputs = [
    sphinx
  ];

  nativeCheckInputs = [
    pytestCheckHook
    beautifulsoup4
  ] ++ passthru.optional-dependencies.social_cards_generation;

  pythonImportsCheck = [ "sphinxext.opengraph" ];

  meta = with lib; {
    description = "Sphinx extension to generate unique OpenGraph metadata";
    homepage = "https://github.com/wpilibsuite/sphinxext-opengraph";
    changelog = "https://github.com/wpilibsuite/sphinxext-opengraph/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi ];
  };
}
