{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  setuptools-git-versioning,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "slskd-api";
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bigoulours";
    repo = "slskd-python-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rEfBT13NutwCfrWcxQf67rhtmxlB8Ws6RY8fObidSs8=";
  };

  nativeBuildInputs = [ setuptools-git-versioning ];

  dependencies = [ requests ];

  pythonImportsCheck = [ "slskd_api" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "API Wrapper to interact with slskd";
    homepage = "https://slskd-api.readthedocs.io/";
    changelog = "https://github.com/bigoulours/slskd-python-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ hougo ];
  };
})
