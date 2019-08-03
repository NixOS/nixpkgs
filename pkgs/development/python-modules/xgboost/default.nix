{ buildPythonPackage
, pytest
, nose
, scipy
, scikitlearn
, stdenv
, xgboost
, substituteAll
, pandas
, matplotlib
, graphviz
, datatable
}:

buildPythonPackage rec {
  pname = "xgboost";
  inherit (xgboost) version src meta;

  patches = [
    (substituteAll {
      src = ./lib-path-for-python.patch;
      libpath = "${xgboost}/lib";
      extention = stdenv.hostPlatform.extensions.sharedLibrary;
    })
  ];

  postPatch = "cd python-package";

  propagatedBuildInputs = [ scipy ];
  buildInputs = [ xgboost ];
  checkInputs = [ nose pytest scikitlearn pandas matplotlib graphviz datatable ];

  checkPhase = ''
    ln -sf ../demo .
    nosetests ../tests/python
  '';
}
