{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pandas,
  streamlit,
}:

buildPythonPackage rec {
  pname = "streamlit-kpi-card";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pjoachims";
    repo = "streamlit-kpi-card";
    tag = version;
    hash = "sha256-w2hUEad6sMFq/KbYnNX7E/vOkIqsLwJZmzdgQTSVMm4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=45,<70" "setuptools"
  '';

  build-system = [ setuptools ];

  dependencies = [
    pandas
    streamlit
  ];

  pythonImportsCheck = [ "streamlit_kpi_card" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "KPI cards for Streamlit";
    homepage = "https://github.com/pjoachims/streamlit-kpi-card";
    changelog = "https://github.com/pjoachims/streamlit-kpi-card/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
