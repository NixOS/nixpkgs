{ lib
, stdenv
, fetchPypi
, buildPythonPackage
, zope_testrunner
, manuel
, docutils
, pygments
}:

buildPythonPackage rec {
  pname = "ZConfig";
  version = "3.6.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RCLH1mOvdizXeVd1NmvGpnq0QKGreW6w90JbDpA08HY=";
  };

  patches = lib.optional stdenv.hostPlatform.isMusl ./remove-setlocale-test.patch;

  buildInputs = [ manuel docutils ];
  propagatedBuildInputs = [ zope_testrunner ];
  nativeCheckInputs = [ pygments ];

  meta = with lib; {
    description = "Structured Configuration Library";
    homepage = "https://pypi.python.org/pypi/ZConfig";
    license = licenses.zpl20;
    maintainers = [ maintainers.goibhniu ];
  };
}
