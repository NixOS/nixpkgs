{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "tempman";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mwilliamson";
    repo = "python-tempman";
    tag = version;
    hash = "sha256-EHTnlT3vcmyjyyS3QCJXjAuZqOEc0i11rEb6zfX6rDY=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'read("README")' '""'
  '';

  build-system = [ setuptools ];

  pythonImportsCheck = [ "tempman" ];

  # Disabling tests, they rely on dependencies that are outdated and not supported
  doCheck = false;

  passthru.updateScripts = gitUpdater { };

  meta = {
    description = "Create and clean up temporary directories";
    homepage = "https://github.com/mwilliamson/python-tempman";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
