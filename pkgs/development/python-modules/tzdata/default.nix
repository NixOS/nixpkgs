{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "tzdata";
  version = "2021.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4ZxzUfiHUioaxznSEEHlkt3ebdG3ZP3vqPeys1UdPTg=";
  };

  pythonImportsCheck = [ "tzdata" ];

  meta = with lib; {
    description = "Provider of IANA time zone data";
    homepage = "https://github.com/python/tzdata";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
