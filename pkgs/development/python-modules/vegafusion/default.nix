{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pytestCheckHook,
  # Deps
  arro3-core,
  protobuf,
  psutil,
  altair,
  ipywidgets,
  vl-convert-python,
  anywidget,
  polars,
  grpcio,
  pyarrow,
  # optional-dependencies
  duckdb,
  vega-datasets,
  scikit-image,
  jupytext,
  ipykernel,
  selenium,
  flaky,
  tenacity,
}:
buildPythonPackage rec {
  pname = "vegafusion";
  version = "2.0.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hex-inc";
    repo = "vegafusion";
    rev = "v${version}";
    hash = "sha256-yiECw9WGd+03KFOWa+bwR10gQFqzx4Riy6uw2zwdc3s=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-T/4k4ZWiO/AQvCxsbjyLMvV/zKq8ywy2rAQYMsJ73t4=";
  };

  buildAndTestSubdir = "vegafusion-python";

  buildInputs = [ protobuf ];

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  dependencies = [
    arro3-core
    psutil
    altair
    ipywidgets
    vl-convert-python
    anywidget
    polars
    grpcio
    pyarrow
  ];

  optional-dependencies = {
    test = [
      duckdb
      vega-datasets
      scikit-image
      jupytext
      ipykernel
      selenium
      flaky
      tenacity
    ];
  };

  pythonImportsCheck = [ "vegafusion" ];

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.test;

  disabledTests = [
    # Require network access
    "test_input_utc"
    "test_pretransform"
    "test_pretransform_specs"
    "test_transformed_data"

    # Relies on selenium's chromedriver_binary
    "test_jupyter_widget"
  ];

  meta = with lib; {
    description = "Core tools for using VegaFusion from Python";
    homepage = "https://github.com/hex-inc/vegafusion";
    license = lib.licenses.bsd3;
    maintainers = with maintainers; [ wariuccio ];
  };
}
