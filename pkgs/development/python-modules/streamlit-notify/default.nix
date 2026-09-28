{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  packaging,
  pytestCheckHook,
  setuptools,
  streamlit,
}:

buildPythonPackage (finalAttrs: {
  pname = "streamlit-notify";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pgarrett-scripps";
    repo = "Streamlit_Notify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MI+8fh7aKk7kOVxq3677cVWsiMmE0NSXWukN+Bc0noM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    packaging
    streamlit
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "streamlit_notify" ];

  disabledTests = [
    # App is not available
    "TestStreamlitNotifyIntegration"
  ];

  meta = {
    description = "Queues and displays Streamlit Status Elements notifications";
    homepage = "https://github.com/pgarrett-scripps/Streamlit_Notify";
    changelog = "https://github.com/pgarrett-scripps/Streamlit_Notify/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
