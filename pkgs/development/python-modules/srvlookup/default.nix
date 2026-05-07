{
  lib,
  buildPythonPackage,
  dnspython,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "srvlookup";
  version = "3.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "gmr";
    repo = "srvlookup";
    tag = version;
    hash = "sha256-iXbi25HsoNX0hnhwZoFik5ddlJ7i+xml3HGaezj3jgY=";
  };

  propagatedBuildInputs = [ dnspython ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "srvlookup" ];

  meta = {
    description = "Wrapper for dnspython to return SRV records for a given host, protocol, and domain name";
    homepage = "https://github.com/gmr/srvlookup";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ mmlb ];
  };
}
