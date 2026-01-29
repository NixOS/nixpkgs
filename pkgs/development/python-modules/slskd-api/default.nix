{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  setuptools-git-versioning,
}:

buildPythonPackage rec {
  pname = "slskd-api";
  version = "0.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bigoulours";
    repo = "slskd-python-api";
    tag = "v${version}";
    hash = "sha256-Kyzbd8y92VFzjIp9xVbhkK9rHA/6KCCJh7kNS/MtixI=";
  };

  nativeBuildInputs = [ setuptools-git-versioning ];

  dependencies = [ requests ];

  pythonImportsCheck = [ "slskd_api" ];

  meta = {
    description = "API Wrapper to interact with slskd";
    homepage = "https://slskd-api.readthedocs.io/";
    changelog = "https://github.com/bigoulours/slskd-python-api/releases/tag/${src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ getchoo ];
  };
}
