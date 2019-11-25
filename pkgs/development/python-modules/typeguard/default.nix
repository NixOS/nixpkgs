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
  version = "2.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5269435c8c98f4c4861dd69f3de755aaab5e163991b7ce1e0eff7ae6472957dd";
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
    homepage = https://github.com/agronholm/typeguard;
    license = licenses.mit;
  };
}
