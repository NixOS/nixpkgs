{ buildPythonPackage
, fetchPypi
, pythonOlder
, stdenv
, setuptools_scm
, pytest
, glibcLocales
}:

buildPythonPackage rec {
  pname = "typeguard";
  version = "2.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e718f493d805d596cba238a61aa83b874530a333783ca9d597fe5bf27143f042";
  };

  buildInputs = [ setuptools_scm ];
  nativeBuildInputs = [ glibcLocales ];

  LC_ALL="en_US.utf-8";

  postPatch = ''
    substituteInPlace setup.cfg --replace " --cov" ""
  '';

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test .
  '';

  disabled = pythonOlder "3.3";

  meta = with stdenv.lib; {
    description = "This library provides run-time type checking for functions defined with argument type annotations";
    homepage = "https://github.com/agronholm/typeguard";
    license = licenses.mit;
  };
}
