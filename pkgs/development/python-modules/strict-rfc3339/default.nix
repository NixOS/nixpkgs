{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "strict-rfc3339";
  version = "0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5cad17bedfc3af57b399db0fed32771f18fc54bbd917e85546088607ac5e1277";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/danielrichman/strict-rfc3339";
    license = licenses.gpl3;
    description = "Strict, simple, lightweight RFC3339 functions";
    maintainers = with maintainers; [ vanschelven ];
  };
}
