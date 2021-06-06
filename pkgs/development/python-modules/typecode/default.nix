{ lib
, fetchPypi
, buildPythonPackage
, setuptools-scm
, attrs
, pdfminer
, commoncode
, plugincode
, binaryornot
, typecode-libmagic
, pytestCheckHook
, pytest-xdist
}:
buildPythonPackage rec {
  pname = "typecode";
  version = "21.2.24";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eaac8aee0b9c6142ad44671252ba00748202d218347d1c0451ce6cd76561e01b";
  };

  dontConfigure = true;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    attrs
    pdfminer
    commoncode
    plugincode
    binaryornot
    typecode-libmagic
  ];

  checkInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  pythonImportsCheck = [
    "typecode"
  ];

  meta = with lib; {
    description = "Comprehensive filetype and mimetype detection using libmagic and Pygments";
    homepage = "https://github.com/nexB/typecode";
    license = licenses.asl20;
    maintainers = teams.determinatesystems.members;
  };
}
