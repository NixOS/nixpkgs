{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  click,
  urllib3,
  requests,
  pytest,
}:
buildPythonPackage (finalAttrs: {
  pname = "waybackpy";
  version = "3.0.6";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-SXo3F1arp2ROt62g69TtsVy4xTvBNMyXO/AjoSyv+D8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    urllib3
    requests
  ];

  nativeBuildInputs = [ pytest ];

  pythonImportsCheck = [ "waybackpy" ];

  meta = {
    homepage = "https://akamhy.github.io/waybackpy/";
    description = "Wayback Machine API interface & a command-line tool";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chpatrick ];
  };
})
