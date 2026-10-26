{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage (finalAttrs: {
  pname = "upnpy";
  version = "1.1.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "5kyc0d3r";
    repo = "upnpy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TsvHsjbuI8QSpsfr/tjBHE+AHDmZhSXEIRVQzWtlOJ8=";
  };

  # Project has not published tests yet
  doCheck = false;
  pythonImportsCheck = [ "upnpy" ];

  meta = {
    description = "UPnP client library for Python";
    homepage = "https://github.com/5kyc0d3r/upnpy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
