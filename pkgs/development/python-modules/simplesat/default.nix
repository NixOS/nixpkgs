{ buildPythonPackage
, fetchFromGitHub
, writeText
, lib

, attrs
, six
, okonomiyaki
}:

let

  versionFile = writeText "simplesat_ver" ''
    # THIS FILE IS GENERATED FROM SETUP_EXT
    version = '0.8.2'
    full_version = '0.8.2'
    git_revision = '4ce881644c872e629358e31f37bc8d099ce42591'
    is_released = True

    msi_version = '0.8.2.843'

    version_info = (0, 8, 2, 'final', 0)
  '';

in buildPythonPackage rec {
  pname = "simplesat";
  version = "0.8.2";

  propagatedBuildInputs = [ attrs six okonomiyaki ];

  src = fetchFromGitHub {
    owner = "enthought";
    repo = "sat-solver";
    rev = "v${version}";
    hash = "sha256-6BQn1W2JGrMmNqgxi+sXx06XzNMcvwqYGMkpD0SSpT8=";
  };

  preConfigure = "cp ${versionFile} simplesat/_version.py";
  setuptoolsCheckPhase = "true";

  meta = with lib; {
    homepage = "https://github.com/enthought/sat-solver";
    description = "Prototype for SAT-based dependency handling";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.bsd3;
  };
}
