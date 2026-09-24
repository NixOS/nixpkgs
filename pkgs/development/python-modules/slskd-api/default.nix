{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  python,
}:

buildPythonPackage rec {
  pname = "slskd-api";
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bigoulours";
    repo = "slskd-python-api";
    tag = "v${version}";
    hash = "sha256-rEfBT13NutwCfrWcxQf67rhtmxlB8Ws6RY8fObidSs8=";
  };

  build-system = with python.pkgs; [
    setuptools
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "setup_requires = [\"setuptools-git-versioning\"]," "version = \"${version}\","
  '';

  dependencies = with python.pkgs; [
    requests
  ];

  pythonImportsCheck = [ "slskd_api" ];

  meta = {
    homepage = "https://github.com/bigoulours/slskd-python-api";
    description = "Python API client for the Soulseek file sharing network (slskd).";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ azban ];
  };
}
