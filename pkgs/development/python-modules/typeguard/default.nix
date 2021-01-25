{ buildPythonPackage
, fetchPypi
, pythonOlder
, lib
, setuptools_scm
, pytest
, typing-extensions
, glibcLocales
}:

buildPythonPackage rec {
  pname = "typeguard";
  version = "2.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d830132dcd544d3f8a2a842ea739eaa0d7c099fcebb9dcdf3802f4c9929d8191";
  };

  buildInputs = [ setuptools_scm ];
  nativeBuildInputs = [ glibcLocales ];

  LC_ALL="en_US.utf-8";

  postPatch = ''
    substituteInPlace setup.cfg --replace " --cov" ""
  '';

  checkInputs = [ pytest typing-extensions ];

  checkPhase = ''
    py.test .
  '';

  disabled = pythonOlder "3.3";

  meta = with lib; {
    description = "This library provides run-time type checking for functions defined with argument type annotations";
    homepage = "https://github.com/agronholm/typeguard";
    license = licenses.mit;
  };
}
