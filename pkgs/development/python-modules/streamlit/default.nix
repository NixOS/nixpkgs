{ lib
, stdenv
, altair
, blinker
, buildPythonPackage
, cachetools
, click
, fetchPypi
, gitpython
, importlib-metadata
, numpy
, packaging
, pandas
, pillow
, protobuf
, pyarrow
, pydeck
, pympler
, python-dateutil
, pythonOlder
, setuptools
, requests
, rich
, tenacity
, toml
, tornado
, typing-extensions
, tzlocal
, validators
, watchdog
}:

buildPythonPackage rec {
  pname = "streamlit";
  version = "1.29.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tt//nF4TLlUYySFQ781FKYDbSSpF+v6sPUaI0jNO+gc=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    altair
    blinker
    cachetools
    click
    gitpython
    importlib-metadata
    numpy
    packaging
    pandas
    pillow
    protobuf
    pyarrow
    pydeck
    pympler
    python-dateutil
    requests
    rich
    tenacity
    toml
    tornado
    typing-extensions
    tzlocal
    validators
  ] ++ lib.optionals (!stdenv.isDarwin) [
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
    maintainers = with maintainers; [ natsukium yrashk ];
    license = licenses.asl20;
  };
}
