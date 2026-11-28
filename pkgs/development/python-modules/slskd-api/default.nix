{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  setuptools,
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

  # setuptools-git-versioning needs .git to find the version.
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'setup_requires = ["setuptools-git-versioning"],' 'version = "${finalAttrs.version}",'
    sed -i '/setuptools_git_versioning={/,/},/d' setup.py
  '';

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # Tests need a running slskd instance and network access.
  doCheck = false;

  pythonImportsCheck = [ "slskd_api" ];

  meta = {
    description = "Python wrapper for the slskd API";
    homepage = "https://github.com/bigoulours/slskd-python-api";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ xelden ];
  };
})
