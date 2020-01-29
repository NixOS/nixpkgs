{ lib
, buildPythonPackage
, fetchPypi
, click
, dataclasses
, jsonschema
, matplotlib
, numpy
, pandas
, regional
, semantic-version
, scikitimage
, scikitlearn
, scipy
, showit
, slicedimage
, sympy
, tqdm
, trackpy
, validators
, xarray
, ipywidgets
, pytest
, pythonOlder
}:

buildPythonPackage rec {
  pname = "starfish";
  version = "0.1.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0340e37b732e184081b150f21bbbd4eed3643ab49f74633b9c4d827bda663235";
  };

  propagatedBuildInputs = [
    click
    jsonschema
    matplotlib
    numpy
    pandas
    regional
    semantic-version
    scikitimage
    scikitlearn
    scipy
    showit
    slicedimage
    sympy
    tqdm
    trackpy
    validators
    xarray
    ipywidgets
    ] ++ lib.optionals (pythonOlder "3.7") [ dataclasses ];

  checkInputs = [
    pytest
  ];

  postConfigure = ''
    substituteInPlace REQUIREMENTS.txt \
      --replace "slicedimage==3.1.1" "slicedimage"
  '';

  checkPhase = ''
    # a few tests < 5% require
    rm -rf starfish/test/full_pipelines/*
    pytest starfish \
      --ignore starfish/core/config/test/test_config.py \
      --ignore starfish/core/experiment/builder/test/test_build.py \
      --ignore starfish/core/experiment/test/test_experiment.py \
      --ignore starfish/core/image/_filter/test/test_reduce.py \
      --ignore starfish/core/image/_registration/_apply_transform/test/test_warp.py \
      --ignore starfish/core/image/_registration/_learn_transform/test/test_translation.py \
      --ignore starfish/core/image/_registration/test/test_transforms_list.py \
      --ignore starfish/core/imagestack/test/test_max_proj.py \
      --ignore starfish/core/recipe/test/test_recipe.py \
      --ignore starfish/core/recipe/test/test_runnable.py \
      --ignore starfish/core/test/test_profiler.py
  '';

  meta = with lib; {
    description = "Pipelines and pipeline components for the analysis of image-based transcriptomics data";
    homepage = https://spacetx-starfish.readthedocs.io/en/latest/;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
    broken = true; # incompatible with latest python-dateutil, scikit-image
  };
}
