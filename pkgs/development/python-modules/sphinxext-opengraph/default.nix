{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  sphinx,
  matplotlib,
  pytestCheckHook,
  pythonOlder,
  beautifulsoup4,
  flit-core,
}:

buildPythonPackage rec {
  pname = "sphinxext-opengraph";
  version = "0.13.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

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

  meta = with lib; {
    description = "Sphinx extension to generate unique OpenGraph metadata";
    homepage = "https://github.com/wpilibsuite/sphinxext-opengraph";
    changelog = "https://github.com/wpilibsuite/sphinxext-opengraph/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi ];
  };
}
