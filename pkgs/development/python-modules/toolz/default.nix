{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "toolz";
  version = "0.12.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7Mo0JmSJPxd6E9rA5rQcvYrCWjWOXyFTFtQ+IQAiT00=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/pytoolz/toolz";
    description = "List processing tools and functional utilities";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
  };
}
