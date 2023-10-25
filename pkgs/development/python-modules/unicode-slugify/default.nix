{ lib
, buildPythonPackage
, fetchPypi
, nose
, six
, unidecode
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "unicode-slugify";
  version = "0.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "25f424258317e4cb41093e2953374b3af1f23097297664731cdb3ae46f6bd6c3";
  };

  propagatedBuildInputs = [ six unidecode ];

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
