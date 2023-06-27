{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, pythonRelaxDepsHook
, requests
, pydantic
, aiohttp
, inflection
, fluent-logger
, toml
, click
, semver
, tiktoken
}:

buildPythonPackage rec {
  pname = "steamship";
  version = "2.17.7";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NkSyX+ajNFwkgO0Lq4UfrvjADgHXiT2oLp2RCQDJv0w=";
  };

  pythonRelaxDeps = [
    "requests"
  ];

  nativeBuildInputs = [
    setuptools-scm
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    requests
    pydantic
    aiohttp
    inflection
    fluent-logger
    toml
    click
    semver
    tiktoken
  ];

  # almost all tests require "steamship api key"
  doCheck = false;

  pythonImportsCheck = [
    "steamship"
  ];

  meta = with lib; {
    description = "The fastest way to add language AI to your product";
    homepage = "https://www.steamship.com/";
    changelog = "https://github.com/steamship-core/python-client/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
