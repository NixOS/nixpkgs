{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, setuptools
, lazr-uri
}:

buildPythonPackage rec {
  pname = "wadllib";
  version = "1.3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "84fecbaec2fef5ae2d7717a8115d271f18c6b5441eac861c58be8ca57f63c1d3";
  };

  propagatedBuildInputs = [ setuptools lazr-uri ];

  doCheck = isPy3k;

  meta = with lib; {
    description = "Navigate HTTP resources using WADL files as guides";
    homepage = "https://launchpad.net/wadllib";
    license = licenses.lgpl3;
    maintainers = [ maintainers.marsam ];
  };
}
