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
  version = "2.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "devbisme";
    repo = "skidl";
    tag = version;
    sha256 = "sha256-EzKtXdQFB6kjaIuCYAsyFPlwmkefb5RJcnpFYCVHHb8=";
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

  meta = with lib; {
    description = "SKiDL is a module that extends Python with the ability to design electronic circuits";
    mainProgram = "netlist_to_skidl";
    homepage = "https://devbisme.github.io/skidl/";
    license = licenses.mit;
    maintainers = with maintainers; [ matthuszagh ];
  };
}
