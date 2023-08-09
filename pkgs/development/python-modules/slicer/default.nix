{ lib
, buildPythonPackage
, dos2unix
, fetchpatch
, fetchPypi
, pytestCheckHook
, pythonOlder
, pandas
, torch
, scipy
}:

buildPythonPackage rec {
  pname = "slicer";
  version = "0.0.7";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9dX3tF+Y0VW5wLplVPqXcMaybVeTo+d6EDD7VpEOvuw=";
  };

  prePatch = ''
    dos2unix slicer/*
  '';

  patches = [
    # these patches add support for numpy>=1.24
    (fetchpatch {
      url = "https://github.com/interpretml/slicer/commit/028e09e639c4a3c99abe1d537cce30af2eebb081.patch";
      hash = "sha256-jh/cbz7cx2ks6jMNh1gI1n5RS/OHBtSIDZRxUGyrl/I=";
    })
    (fetchpatch {
      url = "https://github.com/interpretml/slicer/commit/d4bb09f136d7e1f64711633c16a37e7bee738696.patch";
      hash = "sha256-9rh99s4JWF4iKClZ19jvqSeRulL32xB5Use8PGkh/SA=";
    })
    (fetchpatch {
      url = "https://github.com/interpretml/slicer/commit/74b3683a5a7bd982f9eaaf8d8d665dfdaf2c6604.patch";
      hash = "sha256-R3zsC3udYPFUT93eRhb6wyc9S5n2wceiOunWJ8K+648=";
    })
  ];

  nativeBuildInputs = [
    dos2unix
  ];

  nativeCheckInputs = [ pytestCheckHook pandas torch scipy ];

  disabledTests = [
    # IndexError: too many indices for array
    "test_slicer_sparse"
    "test_operations_2d"
  ];

  meta = with lib; {
    description = "Wraps tensor-like objects and provides a uniform slicing interface via __getitem__";
    homepage = "https://github.com/interpretml/slicer";
    license = licenses.mit;
    maintainers = with maintainers; [ evax ];
    platforms = platforms.unix;
  };
}
