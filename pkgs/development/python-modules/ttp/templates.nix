{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "ttp-templates";
  version = "0.1.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "ttp_templates";
    inherit version;
    sha256 = "0vg7k733i8jqnfz8mpq8kzr2l7b7drk29zkzik91029f6w7li007";
  };

  # drop circular dependency on ttp
  postPatch = ''
    substituteInPlace setup.py --replace '"ttp>=0.6.0"' ""
  '';

  # circular dependency on ttp
  doCheck = false;

  meta = with lib; {
    description = "Template Text Parser Templates";
    homepage = "https://github.com/dmulyalin/ttp_templates";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
