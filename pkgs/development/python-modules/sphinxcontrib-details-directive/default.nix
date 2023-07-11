{ lib
, buildPythonPackage
, fetchPypi
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-details-directive";
  version = "0.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eL1qZ/eGohhoq/DmpZczQNfnpv1xsYkN6chW+Sh3s4s=";
  };

  propagatedBuildInputs = [
    sphinx
  ];

  pythonImportsCheck = [ "sphinxcontrib.details.directive" ];

  meta = with lib; {
    description = "details+summary directive for Sphinx";
    longDescription = ''
      It enables details directive as an element to represent <details> element
      in HTML output. It will be converted into mere paragraphs in other output
      formats.
    '';
    homepage = "https://github.com/sphinx-contrib/sphinxcontrib-details-directive";
    license = licenses.asl20;
    maintainers = with maintainers; [ toastal ];
  };
}
