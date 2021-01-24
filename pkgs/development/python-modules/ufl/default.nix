{ stdenv
, lib
, fetchurl
, python3Packages
, dolfin
}:

python3Packages.buildPythonPackage rec {
  pname = "ufl";
  inherit (dolfin) version;

  src = fetchurl {
    url = "https://bitbucket.org/fenics-project/ufl/downloads/ufl-${version}.tar.gz";
    sha256 = "04daxwg4y9c51sdgvwgmlc82nn0fjw7i2vzs15ckdc7dlazmcfi1";
  };

  propagatedBuildInputs = with python3Packages; [ numpy six ];

  checkInputs = with python3Packages; [ pytest ];

  checkPhase = ''
    runHook preCheck
    py.test test/
    runHook postCheck
  '';

  pythonImportsCheck = [ "ufl" ];

  meta = with lib; {
    description = "A domain-specific language for finite element variational forms";
    homepage = "https://fenicsproject.org/";
    license = with licenses; [ lgpl3Plus ];
  };
}
