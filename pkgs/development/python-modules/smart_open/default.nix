{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, boto
, bz2file
, moto
, requests
, responses
}:

buildPythonPackage rec {
  pname = "smart_open";
  name = "${pname}-${version}";
  version = "1.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0m5j71f7f36s17v4mwv0bxg4azknvcy82rbjp28b4vifrjd6dm7s";
  };

  propagatedBuildInputs = [ boto bz2file requests responses moto ];
  meta = {
    license = lib.licenses.mit;
    description = "smart_open is a Python 2 & Python 3 library for efficient streaming of very large file";
    maintainers = with lib.maintainers; [ jpbernardy ];
  };
}
