{ lib, buildPythonPackage, fetchPypi, h11, enum34 }:

buildPythonPackage rec {
  pname = "wsproto";
  version = "0.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "092qk4pbyaxx8b81hv9p7pc3ww54bwfqybhya4madka3pgv19wh2";
  };

  propagatedBuildInputs = [ h11 enum34 ];

}
