{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "upnpy";
  version = "1.1.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "5kyc0d3r";
    repo = "upnpy";
    rev = "v${version}";
    sha256 = "17rqcmmwsl0m4722b1cr74f80kqwq7cgxsy7lq9c88zf6srcgjsf";
  };

  # Project has not published tests yet
  doCheck = false;
  pythonImportsCheck = [ "upnpy" ];

  meta = with lib; {
    description = "UPnP client library for Python";
    homepage = "https://github.com/5kyc0d3r/upnpy";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
