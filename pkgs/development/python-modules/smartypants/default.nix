{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPyPy,
  setuptools,
  docutils,
  pygments,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "smartypants";
  version = "2.0.2";
  pyproject = true;

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "leohemsted";
    repo = "smartypants.py";
    tag = "v${version}";
    hash = "sha256-jSGiT36Rr0P6eEWZIHtMj4go3KGDRaF2spLxLNruDec=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    docutils
    pygments
    pytestCheckHook
  ];

  preCheck = ''
    patchShebangs smartypants
  '';

  meta = {
    description = "Translate plain ASCII quotation marks and other characters into “smart” typographic HTML entities";
    homepage = "https://github.com/leohemsted/smartypants.py";
    changelog = "https://github.com/leohemsted/smartypants.py/blob/v${version}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dotlambda ];
    mainProgram = "smartypants";
  };
}
