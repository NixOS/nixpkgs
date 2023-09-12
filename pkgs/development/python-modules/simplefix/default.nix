{ lib, python, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "simplefix";
  version = "1.0.16";

  src = fetchFromGitHub {
    repo = "simplefix";
    owner = "da4089";
    rev = "refs/tags/v${version}";
    hash = "sha256-dkwmWCOeTAoeSY8+1wg7RWX/d57JWc8bGagzrEPMAIU=";
  };

  checkPhase = ''
    cd test
    ${python.interpreter} -m unittest all
  '';

  meta = with lib; {
    description = "Simple FIX Protocol implementation for Python";
    homepage = "https://github.com/da4089/simplefix";
    license = licenses.mit;
    maintainers = with maintainers; [ catern ];
  };
}
