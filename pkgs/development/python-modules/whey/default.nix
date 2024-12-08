{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
  attrs,
  click,
  consolekit,
  dist-meta,
  dom-toml,
  domdf-python-tools,
  handy-archives,
  natsort,
  packaging,
  pyproject-parser,
  shippinglabel,
}:
buildPythonPackage rec {
  pname = "whey";
  version = "0.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-l72fjczuuDXg/cDiqJ7roNVm4X+au+1u4AA8Szs1bNo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    attrs
    click
    consolekit
    dist-meta
    dom-toml
    domdf-python-tools
    handy-archives
    natsort
    packaging
    pyproject-parser
    shippinglabel
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools!=61.*,<=67.1.0,>=40.6.0"' '"setuptools"'
  '';

  meta = {
    description = "A simple Python wheel builder for simple projects.";
    homepage = "https://pypi.org/project/whey";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tyberius-prime ];
  };
}
