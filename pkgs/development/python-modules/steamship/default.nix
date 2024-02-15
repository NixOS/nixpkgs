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
  version = "2.17.33";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hvvXg+V/VKTWWdqXM7Q1K5awemkGhSz64gV7HeRBXfg=";
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
    # https://github.com/steamship-core/python-client/issues/503
    broken = versionAtLeast pydantic.version "2";
  };
}
