{ lib
, buildPythonPackage
, fetchFromGitHub
, future
, kinparse
, pyspice
, graphviz
}:

buildPythonPackage rec {
  pname = "skidl";
  version = "1.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "xesscorp";
    repo = "skidl";
    rev = version;
    sha256 = "1m0hllvmr5nkl4zy8yyzfgw9zmbrrzd5pw87ahd2mq68fjpcaqq5";
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
    homepage = "https://xess.com/skidl/docs/_site/";
    license = licenses.mit;
    maintainers = with maintainers; [ matthuszagh ];
  };
}
