{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, quantities
, numpy
}:

buildPythonPackage rec {
  pname = "semantic";
  version = "1.0.3";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "bbc47dad03dddb1ba5895612fdfa1e43cfb3c497534976cebacd4f3684b505b4";
  };

  propagatedBuildInputs = [ quantities numpy ];

  # strange setuptools error (can not import semantic.test)
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Common Natural Language Processing Tasks for Python";
    homepage = https://github.com/crm416/semantic;
    license = licenses.mit;
  };

}
