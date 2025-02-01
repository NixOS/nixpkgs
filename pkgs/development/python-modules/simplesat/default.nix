{
  buildPythonPackage,
  fetchFromGitHub,
  writeText,
  lib,
  attrs,
  mock,
  okonomiyaki,
  pytestCheckHook,
  pyyaml,
  setuptools,
  six,
}:

let
  version = "0.9.0";
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
  pyproject = true;

  src = fetchFromGitHub {
    owner = "enthought";
    repo = "sat-solver";
    rev = "refs/tags/v${version}";
    hash = "sha256-8sUOV42MLM3otG3EKvVzKKGAUpSlaTj850QZxZa62bE=";
  };

  preConfigure = ''
    cp ${versionFile} simplesat/_version.py
  '';

  build-system = [ setuptools ];

  dependencies = [
    attrs
    okonomiyaki
    six
  ];

  pythonImportsCheck = [ "simplesat" ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
    pyyaml
  ];

  pytestFlagsArray = [ "simplesat/tests" ];

  meta = with lib; {
    homepage = "https://github.com/enthought/sat-solver";
    description = "Prototype for SAT-based dependency handling";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.bsd3;
  };
}
