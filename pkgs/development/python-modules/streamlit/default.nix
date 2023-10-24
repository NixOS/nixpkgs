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
, pythonRelaxDepsHook
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
  version = "1.27.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version format;
    hash = "sha256-M/muDeW31ZzX2rqHdUxU7IN6dsJKz8QdH45RSPIJA+4=";
  };

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  pythonRelaxDeps = [
    "pillow"
    "pydeck"
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
