{ lib, buildPythonPackage, fetchPypi, simplejson }:

buildPythonPackage rec {
  pname = "uritemplate";
  version = "0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zapwg406vkwsirnzc6mwq9fac4az8brm6d9bp5xpgkyxc5263m3";
  };

  # No tests in archive
  doCheck = false;

  propagatedBuildInputs = [ simplejson ];

  meta = with lib; {
    homepage = https://github.com/uri-templates/uritemplate-py;
    description = "Python implementation of URI Template";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
