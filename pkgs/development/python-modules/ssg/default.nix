{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch

, python

, unittestCheckHook
, pythonRelaxDepsHook

, setuptools

, fire
, python-crfsuite
, tqdm
}:

buildPythonPackage rec {
  pname = "ssg";
  version = "0.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ViZiD";
    repo = "ssg";
    rev = "refs/tags/v${version}";
    hash = "sha256-ENouS4Mq3D39+zwuXCUTRGmz/KLsF00mYDqIdLOgRcQ=";
  };

  patches = [
    (fetchpatch {
      name = "replace-description-file-deprecated-option.patch";
      url = "https://github.com/ViZiD/ssg/commit/1eed4ca64eb8d2c29bab5c1208241b30dc22bb1b.patch";
      hash = "sha256-1CCa6wHNjtqYlWDB5HrpbXkVLbx8slyVLPfjSy9zlWs=";
    })
    (fetchpatch {
      name = "fix-pep420-warning.patch";
      url = "https://github.com/ViZiD/ssg/commit/e8d9f2d6c14b08424659b3bbca9c5e739a071313.patch";
      hash = "sha256-+3ei2oqoQFWQdalYfd213+U0EgPbnzc/lJXFNuXDSG0=";
    })
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    fire
    python-crfsuite
    tqdm
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  pythonRelaxDeps = [
    "fire"
    "python-crfsuite"
    "tqdm"
  ];

  pythonImportsCheck = [ "ssg" ];

  postInstall = ''
    rm -rf $out/${python.sitePackages}/scripts
  '';

  meta = with lib;
    {
      description = "TCRF syllable segmenter for Thai";
      homepage = "https://github.com/ViZiD/ssg";
      license = licenses.asl20;
      maintainers = with maintainers; [ vizid ];
    };
}

