{ stdenv
, buildPythonPackage
, fetchPypi
, pbr
, pytest
}:

buildPythonPackage rec {
  pname = "ssdp";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0yhjqs9jyvwmba8fi72xfi9k8pxy11wkz4iywayrg71ka3la49bk";
  };

  buildInputs = [ pbr ];
  checkInputs = [ pytest ];
  propagatedBuildInputs = [ ];

  meta = with stdenv.lib; {
    homepage = https://github.com/codingjoe/ssdp;
    description = "Python asyncio library for Simple Service Discovery Protocol (SSDP).";
    license = licenses.mit;
    broken = true;
  };
}
