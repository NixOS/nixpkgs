{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, python
, pythonOlder
, setuptools
# Install requires
, typing-extensions
, uvicorn
, starlette
, contextvars
, websockets
, python-multipart
, htmltools
, click
, markdown-it-py
, mdit-py-plugins
, linkify-it-py
, appdirs
, asgiref
, importlib-metadata
# Test inputs
, pytest
, pytest-asyncio
, pytest-playwright
, pytest-xdist
, pytest-timeout
, psutil
, astropy
, timezonefinder
, seaborn
, plotnine
, plotly
}:

buildPythonPackage rec {
  pname = "shiny";
  version = "0.3.3";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rstudio";
    repo = "py-shiny";
    rev = "v${version}";
    hash = "sha256-xaLVaiVKzCTGzTdRDRCkmCr+ZebYl4OdRihsTh+cd88=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    typing-extensions
    uvicorn
    starlette
    contextvars
    websockets
    python-multipart
    htmltools
    click
    markdown-it-py
    mdit-py-plugins
    linkify-it-py
    appdirs
    asgiref
    importlib-metadata
  ];

  nativeCheckInputs = [
    pytest
    pytest-asyncio
    pytest-playwright
    pytest-xdist
    pytest-timeout
    psutil
    astropy
    timezonefinder
    seaborn
    plotnine
    plotly
  ];

  # skip test that has issue with contextvars
  checkPhase = ''
    runHook preCheck
    pytest tests/ -k "not test_coro_hybrid_context"
    runHook postCheck
  '';

  doCheck = true;

  pythonImportsCheck = [ "shiny" ];

  meta = with lib; {
    homepage = "https://shiny.rstudio.com/py/";
    description = "Shiny for Python";
    license = licenses.mit;
    maintainers = with maintainers; [ nviets ];
    platforms = platforms.unix;
  };
}

