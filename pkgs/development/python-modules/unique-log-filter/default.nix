{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "unique-log-filter";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "twizmwazin";
    repo = "unique_log_filter";
    tag = "v${version}";
    hash = "sha256-av1pVPDsO2dto5fhBK74jKfVsVY2ChyUE5NNja2B1Qw=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "unique_log_filter" ];

  meta = {
    description = "Log filter that removes duplicate log messages";
    homepage = "https://github.com/twizmwazin/unique_log_filter";
    changelog = "https://github.com/twizmwazin/unique_log_filter/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
}
