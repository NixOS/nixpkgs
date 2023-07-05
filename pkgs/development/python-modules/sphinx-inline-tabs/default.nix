{ lib
, buildPythonPackage
, fetchFromGitHub
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-inline-tabs";
  version = "2023.04.21";
  format = "flit";

  src = fetchFromGitHub {
    owner = "pradyunsg";
    repo = "sphinx-inline-tabs";
    rev = version;
    hash = "sha256-1oZheHDNOQU0vWL3YClQrJe94WyUJ72bCAF1UKtjJ0w=";
  };

  propagatedBuildInputs = [
    sphinx
  ];

  # no tests, see https://github.com/pradyunsg/sphinx-inline-tabs/issues/6
  doCheck = false;

  pythonImportsCheck = [ "sphinx_inline_tabs" ];

  meta = with lib; {
    description = "Add inline tabbed content to your Sphinx documentation";
    homepage = "https://github.com/pradyunsg/sphinx-inline-tabs";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi ];
  };
}
