{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  urllib3,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "unifiled";
  version = "1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "florisvdk";
    repo = "unifiled";
    rev = "v${finalAttrs.version}";
    sha256 = "1nmqxxhwa0isxdb889nhbp7w4axj1mcrwd3pr9d8nhpw4yj9h3vq";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    urllib3
  ];

  pythonImportsCheck = [ "unifiled" ];

  meta = {
    description = "Python module for Ubiquiti Unifi LED controller";
    homepage = "https://github.com/florisvdk/unifiled";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
