{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  isPyPy,
  setuptools,
  docutils,
  pygments,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "smartypants";
  version = "2.0.1";
  pyproject = true;

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "leohemsted";
    repo = "smartypants.py";
    rev = "refs/tags/v${version}";
    hash = "sha256-V1rV1B8jVADkS0NhnDkoVz8xxkqrsIHb1mP9m5Z94QI=";
  };

  patches = [
    (fetchpatch2 {
      # https://github.com/leohemsted/smartypants.py/pull/21
      name = "smartypants-3.12-compat.patch";
      url = "https://github.com/leohemsted/smartypants.py/commit/ea46bf36343044a7a61ba3acce4a7f188d986ec5.patch";
      hash = "sha256-9lsiiZKFFKHLy7j3y9ff4gt01szY+2AHpWPAKQgKwZg=";
    })
  ];

  build-system = [ setuptools ];

  nativeCheckInputs = [
    docutils
    pygments
    pytestCheckHook
  ];

  preCheck = ''
    patchShebangs smartypants
  '';

  meta = with lib; {
    description = "Python with the SmartyPants";
    homepage = "https://github.com/leohemsted/smartypants.py";
    changelog = "https://github.com/leohemsted/smartypants.py/blob/v${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
    mainProgram = "smartypants";
  };
}
