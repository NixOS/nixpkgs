{
  lib,
  buildPythonPackage,
  fetchPypi,
  nose,
  six,
  unidecode,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "unicode-slugify";
  version = "0.1.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JfQkJYMX5MtBCT4pUzdLOvHyMJcpdmRzHNs65G9r1sM=";
  };

  propagatedBuildInputs = [
    six
    unidecode
  ];

  nativeCheckInputs = [
    nose
    unittestCheckHook
  ];

  meta = with lib; {
    description = "Generates unicode slugs";
    homepage = "https://pypi.org/project/unicode-slugify/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}
