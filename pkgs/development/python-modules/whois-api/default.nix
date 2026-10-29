{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "whois-api";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "whois-api-llc";
    repo = "whois-api-py";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SeBeJ6k2R53LxHov+8t70geqUosk/yBJQCi6GaVteMM=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ requests ];

  # all tests touch internet
  doCheck = false;

  pythonImportsCheck = [ "whoisapi" ];

  meta = {
    description = "Whois API client library for Python";
    homepage = "https://github.com/whois-api-llc/whois-api-py";
    changelog = "https://github.com/whois-api-llc/whois-api-py/blob/${finalAttrs.src.rev}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
