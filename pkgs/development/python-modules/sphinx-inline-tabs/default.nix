{ lib
, buildPythonPackage
, fetchFromGitHub
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-inline-tabs";
  version = "2022.01.02.beta11";
  format = "flit";

  src = fetchFromGitHub {
    owner = "pradyunsg";
    repo = "sphinx-inline-tabs";
    rev = version;
    sha256 = "sha256-k2nOidUk87EZbFsqQ7zr/4eHk+T7wUOYimjbllfneUM=";
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
