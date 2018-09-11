{ stdenv
, buildPythonPackage
, fetchPypi
, runtest
, unittest2
}:

buildPythonPackage rec {
  version = "0.14.1";
  pname = "unicodecsv";

  src = fetchPypi {
    inherit pname version;
    sha256 = "018c08037d48649a0412063ff4eda26eaa81eff1546dbffa51fa5293276ff7fc";
  };

  checkInputs = [ unittest2 ];

  # runtest.py not included with pypi release
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Drop-in replacement for Python2's stdlib csv module, with unicode support";
    homepage = https://github.com/jdunck/python-unicodecsv;
    license = licenses.asl20;
    maintainers = [ maintainers.koral ];
  };
}
