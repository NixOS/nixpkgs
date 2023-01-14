{ lib
, buildPythonPackage
, fetchPypi
, sphinx
, markdown
}:

buildPythonPackage rec {
  pname = "sphinx-markdown-tables";
  version = "0.0.17";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-a8bT1ADqzP7r0ohEa8CN2DCDNnxYuF1A/mwS1371kvE=";
  };

  propagatedBuildInputs = [
    sphinx
    markdown
  ];

  pythonImportsCheck = [ "sphinx_markdown_tables" ];

  meta = with lib; {
    description = "Sphinx extension for rendering tables written in markdown";
    homepage = "https://github.com/ryanfox/sphinx-markdown-tables";
    maintainers = with maintainers; [ Madouura ];
    license = licenses.gpl3;
  };
}
