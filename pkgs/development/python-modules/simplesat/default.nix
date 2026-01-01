{
  lib,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  okonomiyaki,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "simplesat";
  version = "0.9.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "enthought";
    repo = "sat-solver";
    tag = "v${version}";
    hash = "sha256-C3AQN999iuckaY9I0RTI8Uj6hrV4UB1XYvua5VG8hHw=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "version = file: VERSION" "version = ${version}"
  '';

  build-system = [ setuptools ];

  dependencies = [
    attrs
    okonomiyaki
    six
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
    pyyaml
  ];

  pythonImportsCheck = [ "simplesat" ];

  enabledTestPaths = [ "simplesat/tests" ];

<<<<<<< HEAD
  meta = {
    description = "Prototype for SAT-based dependency handling";
    homepage = "https://github.com/enthought/sat-solver";
    changelog = "https://github.com/enthought/sat-solver/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ genericnerdyusername ];
=======
  meta = with lib; {
    description = "Prototype for SAT-based dependency handling";
    homepage = "https://github.com/enthought/sat-solver";
    changelog = "https://github.com/enthought/sat-solver/blob/${src.tag}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ genericnerdyusername ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
