{ lib
, buildPythonPackage
, fetchPypi
, zope_interface
, zope_exceptions
, zope_testing
, six
}:


buildPythonPackage rec {
  pname = "zope.testrunner";
  version = "5.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4869229fc909e4aa8e76665a718f90dc88f73858b32ca5fa3dea6840e9210fb4";
  };

  propagatedBuildInputs = [ zope_interface zope_exceptions zope_testing six ];

  doCheck = false; # custom test modifies sys.path

  meta = with lib; {
    description = "A flexible test runner with layer support";
    homepage = "https://pypi.python.org/pypi/zope.testrunner";
    license = licenses.zpl20;
    maintainers = [ maintainers.goibhniu ];
  };
}
