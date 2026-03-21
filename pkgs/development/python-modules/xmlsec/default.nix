{
  lib,
  buildPythonPackage,
  fetchPypi,
  hypothesis,
  libtool,
  libxml2,
  libxslt,
  lxml,
  pkg-config,
  pkgconfig,
  pytestCheckHook,
  setuptools-scm,
  xmlsec,
}:

buildPythonPackage rec {
  pname = "xmlsec";
  version = "1.3.17";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8/rJrmefZlhZJcwAxfaDmuNsHQMVdhlXHe4YrMBbnAE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==" "setuptools>="
  '';

  build-system = [ setuptools-scm ];

  nativeBuildInputs = [
    pkg-config
    pkgconfig
  ];

  buildInputs = [
    xmlsec
    libxslt
    libxml2
    libtool
  ];

  propagatedBuildInputs = [ lxml ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  disabledTestPaths = [
    # Full git clone required for test_doc_examples
    "tests/test_doc_examples.py"
  ];

  pythonImportsCheck = [ "xmlsec" ];

  meta = {
    description = "Python bindings for the XML Security Library";
    homepage = "https://github.com/mehcode/python-xmlsec";
    changelog = "https://github.com/xmlsec/python-xmlsec/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zhaofengli ];
  };
}
