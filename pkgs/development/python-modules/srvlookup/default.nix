{
  lib,
  buildPythonPackage,
  dnspython,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "srvlookup";
  version = "3.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "gmr";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-iXbi25HsoNX0hnhwZoFik5ddlJ7i+xml3HGaezj3jgY=";
  };

  propagatedBuildInputs = [ dnspython ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "srvlookup" ];

  meta = with lib; {
    description = "Wrapper for dnspython to return SRV records for a given host, protocol, and domain name";
    homepage = "https://github.com/gmr/srvlookup";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ mmlb ];
  };
}
