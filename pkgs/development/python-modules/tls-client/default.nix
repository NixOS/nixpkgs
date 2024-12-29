{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  typing-extensions,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "tls-client";
  version = "1.0.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "FlorianREGAZ";
    repo = "Python-Tls-Client";
    rev = "refs/tags/${version}";
    hash = "sha256-0eH9fA/oQzrgXcQilUdg4AaTqezj1Q9hP9olhZEDeBc=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ typing-extensions ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "tls_client" ];

  meta = with lib; {
    description = "Advanced HTTP Library";
    homepage = "https://github.com/FlorianREGAZ/Python-Tls-Client";
    changelog = "https://github.com/FlorianREGAZ/Python-Tls-Client/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
