{
  lib,
  branca,
  buildPythonPackage,
  fetchFromGitHub,
  folium,
  jinja2,
  pytest-playwright,
  pytest-rerunfailures,
  pytestCheckHook,
  streamlit,
  uv-build,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "streamlit-folium";
  version = "0.26.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "randyzwitch";
    repo = "streamlit-folium";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q4drhYRh+iO/qg4AY2fDszGdUld2NS1CXTtCdOFl8wo=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.8.4,<0.9" "uv_build"
  '';

  build-system = [ uv-build ];

  dependencies = [
    branca
    folium
    jinja2
    streamlit
  ];

  nativeCheckInputs = [
    pytest-playwright
    pytest-rerunfailures
    pytestCheckHook
    streamlit
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "streamlit_folium" ];

  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  disabledTestPaths = [
    # Don't run tests that require chromium
    "tests/test_frontend.py"
  ];

  meta = {
    description = "Streamlit Component for rendering Folium maps";
    homepage = "https://github.com/randyzwitch/streamlit-folium";
    changelog = "https://github.com/randyzwitch/streamlit-folium/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
