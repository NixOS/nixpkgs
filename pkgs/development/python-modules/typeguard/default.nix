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
  version = "2.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "84f7f28bdf43efcf969e79ca2f8008fc176b0997137fc27f3625f103449cd25b";
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
