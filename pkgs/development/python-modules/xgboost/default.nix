{ stdenv
, lib
, pkgs
, buildPythonPackage
, nose
, scipy
, xgboost
}:

buildPythonPackage rec {
  name = "xgboost-${version}";

  inherit (xgboost) version src meta;

  propagatedBuildInputs = [ scipy ];
  checkInputs = [ nose ];

  postPatch = let
    libname = if stdenv.isDarwin then "libxgboost.dylib" else "libxgboost.so";

  in ''
    cd python-package

    sed "s/CURRENT_DIR = os.path.dirname(__file__)/CURRENT_DIR = os.path.abspath(os.path.dirname(__file__))/g" -i setup.py
    sed "/^LIB_PATH.*/a LIB_PATH = [os.path.relpath(LIB_PATH[0], CURRENT_DIR)]" -i setup.py
    cat <<EOF >xgboost/libpath.py
    def find_lib_path():
      return ["${xgboost}/lib/${libname}"]
    EOF
  '';

  postInstall = ''
    rm -rf $out/xgboost
  '';
}
