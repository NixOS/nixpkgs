{ lib
, buildPythonPackage
, fetchPypi
, hypothesis
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "wcag-contrast-ratio";
  version = "0.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aRkrjlwKfQ3F/xGH7rPjmBQWM6S95RxpyH9Y/oftNhw=";
  };

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "test.py"
  ];

  pythonImportsCheck = [ "wcag_contrast_ratio" ];

  meta = with lib; {
    description = "Library for computing contrast ratios, as required by WCAG 2.0";
    homepage = "https://github.com/gsnedders/wcag-contrast-ratio";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
