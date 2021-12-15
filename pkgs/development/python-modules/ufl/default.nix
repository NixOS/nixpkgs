{ stdenv
, lib
, fetchFromBitbucket
, buildPythonPackage
, python3Packages
, numpy
, six
, pytestCheckHook
, dolfin
}:

buildPythonPackage rec {
  pname = "ufl";
  inherit (dolfin) version;

  src = fetchFromBitbucket {
    owner = "fenics-project";
    repo = "ufl";
    rev = version;
    sha256 = "19wq9y8ghx3n7jha57cj64gb0ql1w4rnkw8s7b71j5p2lr9i7z2h";
  };

  propagatedBuildInputs = [ numpy six ];

  checkInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "test/" ];

  pythonImportsCheck = [ "ufl" ];

  meta = with lib; {
    description = "A domain-specific language for finite element variational forms";
    homepage = "https://fenicsproject.org/";
    license = with licenses; [ lgpl3Plus ];
  };
}
