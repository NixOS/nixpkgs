{
  lib,
  stdenv,
  altair,
  blinker,
  buildPythonPackage,
  cachetools,
  click,
  fetchPypi,
  gitpython,
  numpy,
  packaging,
  pandas,
  pillow,
  protobuf,
  pyarrow,
  pydeck,
  setuptools,
  requests,
  rich,
  tenacity,
  toml,
  tornado,
  typing-extensions,
  watchdog,
}:

buildPythonPackage (finalAttrs: {
  pname = "streamlit";
  version = "1.53.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-rmVq87aLS7LWafqXdgYJbyAhvLqhSkVKKQ+OCje6snc=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "packaging" ];

  dependencies = [
    altair
    blinker
    cachetools
    click
    numpy
    packaging
    pandas
    pillow
    protobuf
    pyarrow
    requests
    rich
    tenacity
    toml
    typing-extensions
    gitpython
    pydeck
    tornado
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ watchdog ];

  # pypi package does not include the tests, but cannot be built with fetchFromGitHub
  doCheck = false;

  pythonImportsCheck = [ "streamlit" ];

  postInstall = ''
    rm $out/bin/streamlit.cmd # remove windows helper
  '';

  meta = {
    homepage = "https://streamlit.io/";
    changelog = "https://github.com/streamlit/streamlit/releases/tag/${finalAttrs.version}";
    description = "Fastest way to build custom ML tools";
    mainProgram = "streamlit";
    maintainers = with lib.maintainers; [
      natsukium
      yrashk
    ];
    license = lib.licenses.asl20;
  };
})
