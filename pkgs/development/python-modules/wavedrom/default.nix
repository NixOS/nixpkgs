{ lib
, attrdict
, buildPythonPackage
, cairosvg
, fetchPypi
, pillow
, pytestCheckHook
, pyyaml
, setuptools-scm
, six
, svgwrite
, xmldiff
}:

buildPythonPackage rec {
  pname = "wavedrom";
  version = "2.0.3.post3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MntNXcpZPIElfCAv6lFvepCHR/sRUnw1nwNPW3r39Hs=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    attrdict
    pyyaml
    svgwrite
    six
  ];

  nativeCheckInputs = [
    cairosvg
    pillow
    pytestCheckHook
    xmldiff
  ];

  disabledTests = [
    # Requires to clone a full git repository
    "test_upstream"
  ];

  pythonImportsCheck = [
    "wavedrom"
  ];

  meta = with lib; {
    description = "WaveDrom compatible Python command line";
    homepage = "https://github.com/wallento/wavedrompy";
    license = licenses.mit;
    maintainers = with maintainers; [ airwoodix ];
  };
}
