{
  buildPythonPackage,
  django,
  fetchFromGitHub,
  lib,
  python,
}:

buildPythonPackage rec {
  pname = "telepath";
  version = "0.3.1";
  format = "setuptools";

  src = fetchFromGitHub {
    repo = "telepath";
    owner = "wagtail";
    rev = "v${version}";
    hash = "sha256-MS4Q41WVSrjFmFjv4fztyf0U2+5WkNU79aPEKv/CeUQ=";
  };

  checkInputs = [ django ];

  checkPhase = ''
    ${python.interpreter} -m django test --settings=telepath.test_settings
  '';

  pythonImportsCheck = [ "telepath" ];

<<<<<<< HEAD
  meta = {
    description = "Library for exchanging data between Python and JavaScript";
    homepage = "https://github.com/wagtail/telepath";
    changelog = "https://github.com/wagtail/telepath/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sephi ];
=======
  meta = with lib; {
    description = "Library for exchanging data between Python and JavaScript";
    homepage = "https://github.com/wagtail/telepath";
    changelog = "https://github.com/wagtail/telepath/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sephi ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
