{
  fetchFromGitHub,
  lib,
  python3Packages,
}:
python3Packages.buildPythonPackage rec {
  pname = "slskd-api";
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bigoulours";
    repo = "slskd-python-api";
    rev = "v${version}";
    hash = "sha256-rEfBT13NutwCfrWcxQf67rhtmxlB8Ws6RY8fObidSs8=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-git-versioning
  ];

  dependencies = with python3Packages; [
    requests
  ];

  pythonImportsCheck = [
    "slskd_api"
  ];

  meta = {
    description = "A python wrapper for the slskd api";
    homepage = "https://github.com/bigoulours/slskd-python-api";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ xelden ];
  };
}
