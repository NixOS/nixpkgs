{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  openssl,
}:

buildPythonPackage rec {
  pname = "securestring";
  version = "0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dnet";
    repo = "pysecstr";
    tag = "v${version}";
    hash = "sha256-FV5NUPberA5nqHad8IwkQLMldT1DPqTGpqOwgQ2zSdI=";
  };

  build-system = [ setuptools ];

  buildInputs = [ openssl ];

  pythonImportsCheck = [ "SecureString" ];

  # no upstream tests exist
  doCheck = false;

  meta = {
    description = "Clears the contents of strings containing cryptographic material";
    homepage = "https://github.com/dnet/pysecstr";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ethancedwards8 ];
  };
}
