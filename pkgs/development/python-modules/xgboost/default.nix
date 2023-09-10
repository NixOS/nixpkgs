{ lib
, buildPythonPackage
, pythonOlder
, cmake
, numpy
, scipy
, stdenv
, xgboost
}:

buildPythonPackage {
  pname = "xgboost";
  inherit (xgboost) version src meta;

  disabled = pythonOlder "3.8";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ xgboost ];
  propagatedBuildInputs = [ numpy scipy ];

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

  # test setup tries to download test data with no option to disable
  # (removing sklearn from nativeCheckInputs causes all previously enabled tests to be skipped)
  # and are extremely cpu intensive anyway
  doCheck = false;

  pythonImportsCheck = [
    "xgboost"
  ];

  __darwinAllowLocalNetworking = true;
}
