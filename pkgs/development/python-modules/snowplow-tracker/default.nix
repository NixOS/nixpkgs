{
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  httmock,
  lib,
  pytestCheckHook,
  requests,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "snowplow-tracker";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snowplow";
    repo = "snowplow-python-tracker";
    tag = version;
    hash = "sha256-GfKMoMUUOxiUcUVdDc6YGgO+CVRvFjDtqQU/FrTO41U=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    typing-extensions
  ];

  pythonImportsCheck = [ "snowplow_tracker" ];

  nativeCheckInputs = [
    httmock
    freezegun
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/snowplow/snowplow-python-tracker/blob/${src.tag}/CHANGES.txt";
    description = "Add analytics to your Python and Django apps, webapps and games";
    homepage = "https://github.com/snowplow/snowplow-python-tracker";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
