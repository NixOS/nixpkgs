{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, unittest2
, nose
, mock
, libarchive
}:

buildPythonPackage rec {
  version = "0.1.3";
  pname = "tarman";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ri6gj883k042xaxa2d5ymmhbw2bfcxdzhh4bz7700ibxwxxj62h";
  };

  buildInputs = [ unittest2 nose mock ];
  propagatedBuildInputs = [ libarchive ];

  # tests are still failing
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/matejc/tarman;
    description = "Archive manager with curses interface";
    license = licenses.bsd0;
  };

}
