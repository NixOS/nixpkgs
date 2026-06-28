{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  ifaddr,
  jsonschema,
  pyee,
  tornado,
  zeroconf,
}:

buildPythonPackage (finalAttrs: {
  pname = "webthing";
  version = "0.15.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "WebThingsIO";
    repo = "webthing-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z4GVycdq25QZxuzZPLg6nhj0MAD1bHrsqph4yHgmRhg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    ifaddr
    jsonschema
    pyee
    tornado
    zeroconf
  ];

  # No tests are present
  doCheck = false;

  pythonImportsCheck = [ "webthing" ];

  meta = {
    description = "Python implementation of a Web Thing server";
    homepage = "https://github.com/WebThingsIO/webthing-python";
    license = with lib.licenses; mpl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
