{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "tempman";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mwilliamson";
    repo = "python-tempman";
    rev = version;
    hash = "sha256-EHTnlT3vcmyjyyS3QCJXjAuZqOEc0i11rEb6zfX6rDY=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'read("README")' '""'
  '';

  build-system = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [
    "tempman"
  ];

  meta = {
    description = "Create and clean up temporary directories";
    homepage = "https://github.com/mwilliamson/python-tempman";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
