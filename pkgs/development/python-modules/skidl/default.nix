{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  future,
  kinparse,
  pyspice,
  graphviz,
  sexpdata,
}:
buildPythonPackage rec {
  pname = "skidl";
  version = "2.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "devbisme";
    repo = "skidl";
    tag = "v${version}";
    sha256 = "sha256-7rauFhaLXyZ5SGtEF7qoAbrj/VgP4qpl+BWUeERefb4=";
  };

  propagatedBuildInputs = [
    future
    kinparse
    pyspice
    graphviz
    sexpdata
  ];

  # Checks require availability of the kicad symbol libraries.
  doCheck = false;
  pythonImportsCheck = [ "skidl" ];

  meta = {
    description = "SKiDL is a module that extends Python with the ability to design electronic circuits";
    mainProgram = "netlist_to_skidl";
    homepage = "https://devbisme.github.io/skidl/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthuszagh ];
  };
}
