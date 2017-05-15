{ stdenv
, buildPythonPackage
, fetchFromGitHub
, fetchPypi
, python
, requests
, boto
, moto
, responses
, isPy3k
, mock
}:
let
  bz2file = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "bz2file";
    version = "0.98";

    src = fetchPypi {
      inherit pname version;      
      sha256 = "126s53fkpx04f33a829yqqk8fj4png3qwg4m66cvlmhmwc8zihb4";
    };

    # fails to find a test.support module
    doCheck = false;

    meta = with stdenv.lib; {
      description = "a Python library for reading and writing bzip2-compressed files";
      homepage = https://github.com/nvawda/bz2file;
      license = licenses.asl20;
      maintainers = with maintainers; [ sdll ];
    };    
  };
in buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "smart_open";
  version = "1.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nkw6i9ijmbmx01j8ssb3n7v2va9in2y5z3ksficcxyh62mdf7i3";
  };

  propagatedBuildInputs = [
    boto
    requests
    bz2file
  ];
  buildInputs = [
    mock
    moto
    responses    
  ];

  checkPhase = ''
    ${python.interpreter} setup.py test
  '';
  
  meta = with stdenv.lib; {
    description = "Utils for streaming large files (S3, HDFS, gzip, bz2...)";
    homepage = https://github.com/RaRe-Technologies/smart_open;
    license = licenses.mit;
    maintainers = with maintainers; [ sdll ];
    };
}
