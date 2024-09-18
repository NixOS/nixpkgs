{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  inetutils,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "whois";
  version = "0.99.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "DannyCork";
    repo = "python-whois";
    rev = "refs/tags/${version}";
    hash = "sha256-uKAqpxb72fo0DiaChuJvDizq0z/oFSDHWJuK4vuYIzo=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    # whois is needed
    inetutils
  ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [ "whois" ];

  meta = with lib; {
    description = "Python module/library for retrieving WHOIS information";
    homepage = "https://github.com/DannyCork/python-whois/";
    changelog = "https://github.com/DannyCork/python-whois/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
