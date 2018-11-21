{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "twitter";
  version = "1.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1m6b17irb9klc345k8174pni724jzy2973z2x2jg69h83hipjw2c";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Twitter API library";
    license     = licenses.mit;
    maintainers = with maintainers; [ thoughtpolice ];
  };

}
