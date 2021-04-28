{ lib
, buildPythonPackage
, fetchFromGitHub
, cmake
, ninja
, scikit-build
}:

buildPythonPackage rec {
  pname = "tweedledum";
  version = "1.0.0";
  format = "pyproject";

  src = fetchFromGitHub{
    owner = "boschmitt";
    repo = "tweedledum";
    rev = "v${version}";
    hash = "sha256-59lJzdw9HLJ9ADxp/a3KW4v5aU/dYm27NSYoz9D49i4=";
  };

  nativeBuildInputs = [ cmake ninja scikit-build ];
  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "tweedledum" ];

  # TODO: use pytest, but had issues with finding the correct directories
  checkPhase = ''
    python -m unittest discover -s ./python/test -t .
  '';

  meta = with lib; {
    description = "A library for synthesizing and manipulating quantum circuits";
    homepage = "https://github.com/boschmitt/tweedledum";
    license = licenses.mit ;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
