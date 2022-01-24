{ lib
, attrdict
, buildPythonPackage
, cairosvg
, fetchPypi
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
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-I5s0Nf8RawkAfVUX7tdV/IWRiRtycaHNQNueQAwCRI0=";
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
