{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, future
, kinparse
, enum34
, pyspice
, graphviz
, pillow
, cffi
}:

buildPythonPackage rec {
  pname = "skidl";
  version = "unstable-2020-09-15";

  src = fetchFromGitHub {
    owner = "xesscorp";
    repo = "skidl";
    rev = "551bdb92a50c0894b0802c0a89b4cb62a5b4038f";
    sha256 = "1g65cyxpkqshgsggav2q3f76rbj5pzh7sacyhmhzvfz4zfarkcxk";
  };

  propagatedBuildInputs = [
    requests
    future
    kinparse
    enum34
    pyspice
    graphviz
    pillow
    cffi
  ];

  # Checks require availability of the kicad symbol libraries.
  doCheck = false;
  pythonImportsCheck = [ "skidl" ];

  meta = with lib; {
    description = "SKiDL is a module that extends Python with the ability to design electronic circuits";
    homepage = "https://xesscorp.github.io/skidl/docs/_site/";
    license = licenses.mit;
    maintainers = with maintainers; [ matthuszagh ];
  };
}
