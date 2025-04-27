{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  future,
  kinparse,
  pyspice,
  graphviz,
}:

buildPythonPackage rec {
  pname = "skidl";
  version = "2.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "xesscorp";
    repo = "skidl";
    tag = version;
    sha256 = "sha256-EzKtXdQFB6kjaIuCYAsyFPlwmkefb5RJcnpFYCVHHb8=";
  };

  propagatedBuildInputs = [
    future
    kinparse
    pyspice
    graphviz
  ];

  # Checks require availability of the kicad symbol libraries.
  doCheck = false;
  pythonImportsCheck = [ "skidl" ];

  meta = with lib; {
    description = "Module that extends Python with the ability to design electronic circuits";
    mainProgram = "netlist_to_skidl";
    homepage = "https://xess.com/skidl/docs/_site/";
    license = licenses.mit;
    maintainers = with maintainers; [ matthuszagh ];
  };
}
