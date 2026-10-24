{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyecharts,
  setuptools,
  streamlit,
}:

buildPythonPackage rec {
  pname = "streamlit-echarts";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "andfanilo";
    repo = "streamlit-echarts";
    tag = "v${version}";
    hash = "sha256-xE2TKrov+ZmlAPp+jP+x56PUW46KThkPLKXvFCNKcNQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyecharts
    streamlit
  ];

  # Import registers the component and requires frontend/build
  # pythonImportsCheck = [ "streamlit_echarts" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Streamlit component to render ECharts";
    homepage = "https://github.com/andfanilo/streamlit-echarts";
    changelog = "https://github.com/andfanilo/streamlit-echarts/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
