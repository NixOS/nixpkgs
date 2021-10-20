{ lib
, buildPythonPackage
, fetchPypi
, attrdict
, cairosvg
, pillow
, pytestCheckHook
, setuptools-scm
, six
, svgwrite
, xmldiff
}:

buildPythonPackage rec {
  pname = "wavedrom";
  version = "2.0.3.post2";
  src = fetchPypi {
    inherit pname version;
    sha256 = "239b3435ff116b09007d5517eed755fc8591891b7271a1cd40db9e400c02448d";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    attrdict
    svgwrite
    six
  ];

  checkInputs = [
    pytestCheckHook
    xmldiff
    pillow
    cairosvg
  ];

  disabledTests = [
    "test_upstream"  # requires to clone a full git repository
  ];

  pythonImportsCheck = [ "wavedrom" ];

  meta = {
    description = "WaveDrom compatible Python command line";
    homepage = "https://github.com/wallento/wavedrompy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ airwoodix ];
  };
}
