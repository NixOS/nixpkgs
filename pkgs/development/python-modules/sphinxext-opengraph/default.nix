{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  sphinx,
  matplotlib,
  pytestCheckHook,
  beautifulsoup4,
  flit-core,
}:

buildPythonPackage rec {
  pname = "sphinxext-opengraph";
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wpilibsuite";
    repo = "sphinxext-opengraph";
    tag = "v${version}";
    hash = "sha256-rdV6XWHfNj+TFgIfqFPWYxn6bGG5w/frUHl9+qMALi4=";
  };

  build-system = [ flit-core ];

  optional-dependencies = {
    social_cards_generation = [ matplotlib ];
  };

  propagatedBuildInputs = [ sphinx ];

  nativeCheckInputs = [
    pytestCheckHook
    beautifulsoup4
  ]
  ++ optional-dependencies.social_cards_generation;

  pythonImportsCheck = [ "sphinxext.opengraph" ];

  meta = {
    description = "Sphinx extension to generate unique OpenGraph metadata";
    homepage = "https://github.com/wpilibsuite/sphinxext-opengraph";
    changelog = "https://github.com/wpilibsuite/sphinxext-opengraph/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Luflosi ];
  };
}
