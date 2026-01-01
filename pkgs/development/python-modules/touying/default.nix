{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  jinja2,
  pillow,
  python-pptx,
  typst,
}:

buildPythonPackage rec {
  pname = "touying";
<<<<<<< HEAD
  version = "0.14.4";
=======
  version = "0.13.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "touying-typ";
    repo = "touying-exporter";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-3e5LWI3ysklTj9WY0PF4+7spEARZYel/aS1R+elfMp0=";
=======
    hash = "sha256-gcr3KS2Qm8CMA+8AeC0hbGi9Gjj5sMr6gJkuoZWUEGY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    setuptools
  ];

<<<<<<< HEAD
=======
  pythonRemoveDeps = [
    "argparse"
  ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  dependencies = [
    jinja2
    pillow
    python-pptx
    typst
  ];

  pythonImportsCheck = [ "touying" ];

  # no tests
  doCheck = false;

  meta = {
    description = "Export presentation slides in various formats for Touying";
    changelog = "https://github.com/touying-typ/touying-exporter/releases/tag/${version}";
    homepage = "https://github.com/touying-typ/touying-exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "touying";
  };
}
