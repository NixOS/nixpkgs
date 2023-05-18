{ lib
, buildPythonPackage
, fetchFromGitHub
, isPyPy
, docutils
, pygments
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "2.0.1";
  pname = "smartypants";
  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "leohemsted";
    repo = "smartypants.py";
    rev = "v${version}";
    sha256 = "00p1gnb9pzb3svdq3c5b9b332gsp50wrqqa39gj00m133zadanjp";
  };

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
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
