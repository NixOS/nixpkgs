{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinx-inline-tabs";
  version = "2025.12.21.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pradyunsg";
    repo = "sphinx-inline-tabs";
    tag = version;
    hash = "sha256-aHsTdCVu/e9uaM4ayOfY3IBjjivZwDiHoWA0W2vyvNA=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ sphinx ];

  # no tests, see https://github.com/pradyunsg/sphinx-inline-tabs/issues/6
  doCheck = false;

  pythonImportsCheck = [ "sphinx_inline_tabs" ];

  meta = {
    description = "Add inline tabbed content to your Sphinx documentation";
    homepage = "https://github.com/pradyunsg/sphinx-inline-tabs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Luflosi ];
  };
}
