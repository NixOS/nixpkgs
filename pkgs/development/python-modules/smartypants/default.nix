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
  version = "2.0.1";
  pname = "smartypants";
  pyproject = true;

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "leohemsted";
    repo = "smartypants.py";
    rev = "v${version}";
    sha256 = "00p1gnb9pzb3svdq3c5b9b332gsp50wrqqa39gj00m133zadanjp";
  };

  patches = [
    (fetchpatch2 {
      # https://github.com/leohemsted/smartypants.py/pull/21
      name = "smartypants-3.12-compat.patch";
      url = "https://github.com/leohemsted/smartypants.py/commit/ea46bf36343044a7a61ba3acce4a7f188d986ec5.patch";
      hash = "sha256-9lsiiZKFFKHLy7j3y9ff4gt01szY+2AHpWPAKQgKwZg=";
    })
  ];

  nativeBuildInputs = [ setuptools ];

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
    mainProgram = "smartypants";
    homepage = "https://github.com/leohemsted/smartypants.py";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
