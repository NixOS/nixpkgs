{ stdenv
, buildPythonPackage
, nose
, scipy
, xgboost
, substituteAll
}:

buildPythonPackage rec {
  pname = "xgboost";
  inherit (xgboost) version src meta;

  patches = [
    (substituteAll {
      src = ./lib-path-for-python.patch;
      libpath = "${xgboost}/lib";
    })
  ];

  postPatch = "cd python-package";

  propagatedBuildInputs = [ scipy ];
  buildInputs = [ xgboost ];
  checkInputs = [ nose ];

  checkPhase = ''
    ln -sf ../demo .
    nosetests ../tests/python
  '';
}
