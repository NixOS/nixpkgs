{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  addBinToPathHook,
  writableTmpDirAsHomeHook,
  pytest,
  dicom2nifti,
  nibabel,
  nnunetv2,
  numpy,
  pyarrow,
  requests,
  torch,
  tqdm,
  simpleitk,
  xvfbwrapper,
  xgboost,
}:

buildPythonPackage rec {
  pname = "totalsegmentator";
  version = "2.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wasserth";
    repo = "TotalSegmentator";
    tag = "v${version}";
    hash = "sha256-Tg739ww3EYdPTWxfNdAylwXXkVSLUvsmZ41NqSq90CQ=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    dicom2nifti
    nibabel
    nnunetv2
    numpy
    pyarrow
    requests
    torch
    tqdm
    simpleitk
    xvfbwrapper
    xgboost # not listed in setup.py, but required for totalsegmentator_get_{modality,phase}
  ];

  pythonImportsCheck = [
    "totalsegmentator"
    "totalsegmentator.python_api"
  ];

  nativeCheckInputs = [
    pytest
    addBinToPathHook
    writableTmpDirAsHomeHook
  ];

  checkPhase = ''
    runHook preCheck
    bash tests/tests.sh
    runHook postCheck
  '';

  doCheck = false; # tests try to download data

  meta = {
    description = "Tool for robust segmentation of anatomical structures in CT and MR images";
    homepage = "https://github.com/wasserth/TotalSegmentator";
    mainProgram = "TotalSegmentator";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
