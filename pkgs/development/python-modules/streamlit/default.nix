{
  lib,
  stdenv,
  altair,
  blinker,
  buildPythonPackage,
  cachetools,
  click,
  fetchPypi,
  fetchpatch2,
  gitpython,
  numpy,
  packaging,
  pandas,
  pillow,
  protobuf,
  pyarrow,
  pydeck,
  pythonOlder,
  setuptools,
  requests,
  rich,
  tenacity,
  toml,
  tornado,
  typing-extensions,
  watchdog,
}:

buildPythonPackage rec {
  pname = "streamlit";
  version = "1.51.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HnQqnAtpj0Zsb1v1jTM77aWh++jeZgdDl2eRtcFEbvY=";
  };

  patches = [
    # Allow pyarrow 22
    (fetchpatch2 {
      url = "https://github.com/streamlit/streamlit/commit/b9e1b875a948a0aa6e972edc6e86a4f89706e08c.diff?full_index=1";
      stripLen = 1;
      excludes = [ "tests/streamlit/data_test_cases.py" ];
      hash = "sha256-qZau1XlP8Kf2hPtyFphJN4UEjbp0ZZYngFdRwXTVt3g=";
    })
  ];

  build-system = [
    setuptools
  ];

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

  meta = with lib; {
    homepage = "https://streamlit.io/";
    changelog = "https://github.com/streamlit/streamlit/releases/tag/${version}";
    description = "Fastest way to build custom ML tools";
    mainProgram = "streamlit";
    maintainers = with maintainers; [
      natsukium
      yrashk
    ];
    license = licenses.asl20;
  };
}
