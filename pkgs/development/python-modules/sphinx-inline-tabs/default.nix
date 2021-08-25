{ lib
, buildPythonPackage
, fetchFromGitHub
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-inline-tabs";
  version = "2021.04.11.beta9";
  format = "flit";

  src = fetchFromGitHub {
    owner = "pradyunsg";
    repo = "sphinx-inline-tabs";
    rev = version;
    sha256 = "sha256-UYrLQAXPProjpGPQNkju6+DmzjPG+jbjdKveoeViVTY=";
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
