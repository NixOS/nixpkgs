{ lib
, buildPythonPackage
, pytestCheckHook
, cmake
, scipy
, scikit-learn
, stdenv
, xgboost
, pandas
, matplotlib
, graphviz
, datatable
, hypothesis
}:

buildPythonPackage {
  pname = "xgboost";
  inherit (xgboost) version src meta;

  nativeBuildInputs = [ cmake ];
  buildInputs = [ xgboost ];
  propagatedBuildInputs = [ scipy ];
  checkInputs = [
    pytestCheckHook
    scikit-learn
    pandas
    matplotlib
    graphviz
    datatable
    hypothesis
  ];

  # Override existing logic for locating libxgboost.so which is not appropriate for Nix
  prePatch = let
    libPath = "${xgboost}/lib/libxgboost${stdenv.hostPlatform.extensions.sharedLibrary}";
  in ''
    echo 'find_lib_path = lambda: ["${libPath}"]' > python-package/xgboost/libpath.py
  '';

  dontUseCmakeConfigure = true;

  postPatch = ''
    cd python-package
  '';

  preCheck = ''
    ln -sf ../demo .
    ln -s ${xgboost}/bin/xgboost ../xgboost
  '';

  # tests are extremely cpu intensive, only run basic tests to ensure package is working
  pytestFlagsArray = ["../tests/python/test_basic.py"];
  disabledTestPaths = [
    # Requires internet access: https://github.com/dmlc/xgboost/blob/03cd087da180b7dff21bd8ef34997bf747016025/tests/python/test_ranking.py#L81
    "../tests/python/test_ranking.py"
  ];
  disabledTests = [
    "test_cli_binary_classification"
    "test_model_compatibility"
  ] ++ lib.optionals stdenv.isDarwin [
    # fails to connect to the com.apple.fonts daemon in sandboxed mode
    "test_plotting"
    "test_sklearn_plotting"
  ];

  __darwinAllowLocalNetworking = true;
}
