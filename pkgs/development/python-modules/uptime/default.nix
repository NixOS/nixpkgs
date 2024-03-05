{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "uptime";
  version = "3.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wr9jkixprlywz0plyn5p42a5fd31aiwvjrxdvj7r02vfxa04c3w";
  };

  meta = with lib; {
    homepage = "https://github.com/Cairnarvon/uptime";
    description = "Cross-platform way to retrieve system uptime and boot time";
    license = licenses.bsd2;
    maintainers = with maintainers; [ rob ];
  };

}
