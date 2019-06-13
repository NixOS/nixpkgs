{ stdenv
, buildPythonPackage
, fetchurl
, sphinx
, isPy3k
}:

buildPythonPackage rec {
  pname = "ttystatus";
  version = "0.23";
  disabled = isPy3k;

  src = fetchurl {
    url = "http://code.liw.fi/debian/pool/main/p/python-ttystatus/python-ttystatus_${version}.orig.tar.gz";
    sha256 = "0ymimviyjyh2iizqilg88g4p26f5vpq1zm3cvg7dr7q4y3gmik8y";
  };

  buildInputs = [ sphinx ];

  # error: invalid command 'test'
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://liw.fi/ttystatus/;
    description = "Progress and status updates on terminals for Python";
    license = licenses.gpl3;
    maintainers = with maintainers; [ rickynils ];
  };

}
