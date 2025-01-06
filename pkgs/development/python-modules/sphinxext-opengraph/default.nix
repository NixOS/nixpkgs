{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  sphinx,
  matplotlib,
  pytestCheckHook,
  pythonOlder,
  beautifulsoup4,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "sphinxext-opengraph";
  version = "0.9.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "wpilibsuite";
    repo = "sphinxext-opengraph";
    tag = "v${version}";
    hash = "sha256-B+bJ1tKqTTlbNeJLxk56o2a21n3Yg6OHwJiFfCx46aw=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  optional-dependencies = {
    social_cards_generation = [ matplotlib ];
  };

  propagatedBuildInputs = [ sphinx ];

  nativeCheckInputs = [
    pytestCheckHook
    beautifulsoup4
  ] ++ optional-dependencies.social_cards_generation;

  pythonImportsCheck = [ "sphinxext.opengraph" ];

  meta = {
    description = "Sphinx extension to generate unique OpenGraph metadata";
    homepage = "https://github.com/wpilibsuite/sphinxext-opengraph";
    changelog = "https://github.com/wpilibsuite/sphinxext-opengraph/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Luflosi ];
  };
}
