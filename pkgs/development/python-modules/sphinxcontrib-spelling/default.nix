{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, sphinx
, importlib-metadata
, pyenchant
, pbr
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-spelling";
  version = "5.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c8250ff02e6033c3aeabc41e91dc185168fecefb0c5722aaa3e2055a829e1e4c";
  };

  propagatedBuildInputs = [ sphinx pyenchant pbr ]
    ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  # No tests included
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Sphinx spelling extension";
    homepage = "https://bitbucket.org/dhellmann/sphinxcontrib-spelling";
    maintainers = with maintainers; [ nand0p ];
    license = licenses.bsd2;
  };

}
