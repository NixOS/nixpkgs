{
  buildPythonPackage,
  fetchFromGitHub,
  writeText,
  lib,
  attrs,
  six,
  okonomiyaki,
}:

let
  version = "0.8.2";
  format = "setuptools";

  versionFile = writeText "simplesat_ver" ''
    version = '${version}'
    full_version = '${version}'
    git_revision = '0000000000000000000000000000000000000000'
    is_released = True
    msi_version = '${version}.000'
    version_info = (${lib.versions.major version}, ${lib.versions.minor version}, ${lib.versions.patch version}, 'final', 0)
  '';
in
buildPythonPackage rec {
  pname = "simplesat";
  inherit version;

  propagatedBuildInputs = [
    attrs
    six
    okonomiyaki
  ];

  src = fetchFromGitHub {
    owner = "enthought";
    repo = "sat-solver";
    rev = "v${version}";
    hash = "sha256-6BQn1W2JGrMmNqgxi+sXx06XzNMcvwqYGMkpD0SSpT8=";
  };

  preConfigure = ''
    cp ${versionFile} simplesat/_version.py
  '';
  dontUseSetuptoolsCheck = true;

  pythonImportsCheck = [ "simplesat" ];

  meta = with lib; {
    homepage = "https://github.com/enthought/sat-solver";
    description = "Prototype for SAT-based dependency handling";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.bsd3;
  };
}
