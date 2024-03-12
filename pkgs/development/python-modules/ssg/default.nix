{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch

, python

, unittestCheckHook

, setuptools

, fire
, python-crfsuite
, tqdm
}:

buildPythonPackage rec {
  pname = "ssg";
  version = "0.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ViZiD";
    repo = "ssg";
    rev = "refs/tags/v${version}";
    hash = "sha256-OBQAqM2oT5tAZPscw0yuB7V17Nii2ITH4ZBIzGyy86o=";
  };

  patches = [
    (fetchpatch {
      name = "replace-description-file-deprecated-option.patch";
      url = "https://github.com/ViZiD/ssg/commit/1eed4ca64eb8d2c29bab5c1208241b30dc22bb1b.patch";
      hash = "sha256-1CCa6wHNjtqYlWDB5HrpbXkVLbx8slyVLPfjSy9zlWs=";
    })
    (fetchpatch {
      name = "fix-pep420-warning.patch";
      url = "https://github.com/ViZiD/ssg/commit/44fa6d70b33b0f6c34f4e3ae0f5b79bc43b75abe.patch";
      hash = "sha256-EN02Eka0dH51iShX2GAddMwZBKinxD/EcTUvg9ZxRZs=";
    })
    (fetchpatch {
      name = "fix-tests-for-featurizer.patch";
      url = "https://github.com/ViZiD/ssg/commit/09be58aae808e8df07222058a46017c8111fe9b2.patch";
      hash = "sha256-STMUtovGl2gOcEy4nYh5WRau+vWDuUaa+eHdUR1P8Ao=";
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

  nativeCheckInputs = [
    unittestCheckHook
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

