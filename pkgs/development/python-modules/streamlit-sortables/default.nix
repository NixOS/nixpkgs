{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  streamlit,
}:

buildPythonPackage rec {
  pname = "streamlit-sortables";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ohtaman";
    repo = "streamlit-sortables";
    rev = "v${version}";
    hash = "sha256-nDUkcPVh/zqYajtcVS2MvHYH3WvcNLuaMEFnEnHJ9NI=";
  };

  build-system = [ poetry-core ];

  dependencies = [ streamlit ];

  pythonImportsCheck = [ "streamlit_sortables" ];

  meta = {
    description = "Streamlit component for sortable items";
    homepage = "https://github.com/ohtaman/streamlit-sortables";
    changelog = "https://github.com/ohtaman/streamlit-sortables/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.carman ];
  };
}
