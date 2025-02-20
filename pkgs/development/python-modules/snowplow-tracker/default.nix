{
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  httmock,
  lib,
  pytestCheckHook,
  requests,
  setuptools,
  types-requests,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "snowplow-tracker";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snowplow";
    repo = "snowplow-python-tracker";
    tag = version;
    hash = "sha256-JYAmVW/+MK0XadF/Mjm3YX+ruSF/SBg0B7IMFz/G+X0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    types-requests
    typing-extensions
  ];

  pythonImportsCheck = [ "snowplow_tracker" ];

  nativeCheckInputs = [
    httmock
    freezegun
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/snowplow/snowplow-python-tracker/releases/tag/${src.tag}";
    description = "Add analytics to your Python and Django apps, webapps and games";
    homepage = "https://github.com/snowplow/snowplow-python-tracker";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
