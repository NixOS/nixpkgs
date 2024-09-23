{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "tlds";
  version = "2024071000";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kichik";
    repo = "tlds";
    rev = "refs/tags/${version}";
    hash = "sha256-xt2IdF7V8NUW9nUg8x7XbMHLWir6CHAQcRIiH6ejV5M=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "tlds" ];

  # no tests
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Automatically updated list of valid TLDs taken directly from IANA";
    homepage = "https://github.com/kichik/tlds";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
