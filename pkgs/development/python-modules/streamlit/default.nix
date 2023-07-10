{ lib
, altair
, blinker
, buildPythonPackage
, cachetools
, click
, fetchPypi
, gitpython
, importlib-metadata
, jinja2
, pillow
, protobuf3
, pyarrow
, pydeck
, pympler
, requests
, rich
, semver
, setuptools
, tenacity
, toml
, tornado
, tzlocal
, validators
, watchdog
}:

buildPythonPackage rec {
  pname = "streamlit";
  version = "1.24.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version format;
    hash = "sha256-/V8LZHmOlwY2RAj7WJt3WVMUpjFdE7LXULljx66X82I=";
  };

  propagatedBuildInputs = [
    altair
    blinker
    cachetools
    click
    gitpython
    importlib-metadata
    jinja2
    pillow
    protobuf3
    pyarrow
    pydeck
    pympler
    requests
    rich
    semver
    setuptools
    tenacity
    toml
    tornado
    tzlocal
    validators
    watchdog
  ];

  # pypi package does not include the tests, but cannot be built with fetchFromGitHub
  doCheck = false;

  pythonImportsCheck = [
    "streamlit"
  ];

  postInstall = ''
    rm $out/bin/streamlit.cmd # remove windows helper
  '';

  meta = with lib; {
    homepage = "https://streamlit.io/";
    changelog = "https://github.com/streamlit/streamlit/releases/tag/${version}";
    description = "The fastest way to build custom ML tools";
    maintainers = with maintainers; [ yrashk ];
    license = licenses.asl20;
  };
}
