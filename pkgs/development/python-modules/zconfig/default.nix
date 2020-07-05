{ stdenv
, fetchPypi
, buildPythonPackage
, zope_testrunner
, manuel
, docutils
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "ZConfig";
  version = "3.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0s7aycxna07a04b4rswbkj4y5qh3gxy2mcsqb9dmy0iimj9f9550";
  };

  patches = stdenv.lib.optional stdenv.hostPlatform.isMusl ./remove-setlocale-test.patch;

  buildInputs = [ manuel docutils ];
  propagatedBuildInputs = [ zope_testrunner ];

  disabled = pythonAtLeast "3.8"; # 3.6.0 introduces compatibility for 3.8 and 3.9

  meta = with stdenv.lib; {
    description = "Structured Configuration Library";
    homepage = "https://pypi.python.org/pypi/ZConfig";
    license = licenses.zpl20;
    maintainers = [ maintainers.goibhniu ];
  };
}
