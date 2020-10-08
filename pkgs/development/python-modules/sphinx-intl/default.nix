{ stdenv
, buildPythonPackage
, fetchPypi
, Babel
, click
, sphinx
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sphinx-intl";
  version = "2.0.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d1q0sanjp4nkfvhsxi75zf3xjyyi8nzxvl3v7l0jy9ld70nwnmj";
  };

  propagatedBuildInputs = [ Babel click sphinx ];

  # package does not contain any tests
  doChecks = false;

  meta = with stdenv.lib; {
    description = "Translation support for Sphinx";
    homepage = "https://github.com/sphinx-doc/sphinx-intl";
    license = licenses.bsd2;
    maintainers = with maintainers; [ euandreh ];
  };
}
