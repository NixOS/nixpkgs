{ stdenv
, buildPythonPackage
, fetchPypi
, zconfig
}:

buildPythonPackage rec {
  pname = "zdaemon";
  version = "4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f249fc6885646d165d7d6b228a7b71f5170fc7117de9e0688271f8fb97840f72";
  };

  propagatedBuildInputs = [ zconfig ];

  # too many deps..
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A daemon process control library and tools for Unix-based systems";
    homepage = https://pypi.python.org/pypi/zdaemon;
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
