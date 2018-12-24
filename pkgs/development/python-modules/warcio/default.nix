{ lib
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "warcio";
  version = "1.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nyhghbag1chh5fml848x799mwgkgmz3l3ipv7lr6p0lj1jq8i1r";
  };

  propagatedBuildInputs = [ six ];

  # Test suite makes DNS lookups and HTTP requests to example.com
  # Most tests fail with OSError: [Errno 9] Bad file descriptor
  doCheck = false;

  meta = with lib; {
    description = "Streaming WARC/ARC library for fast web archive IO";
    homepage = https://github.com/webrecorder/warcio;
    license = licenses.asl20;
    maintainers = with maintainers; [ ivan ];
  };
}
