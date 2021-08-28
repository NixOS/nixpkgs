{ lib, python, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "simplefix";
  version = "1.0.14";

  src = fetchFromGitHub {
    repo = "simplefix";
    owner = "da4089";
    rev = "v${version}";
    sha256 = "1qccb63w6swq7brp0zinkkngpazmb25r21adry5cq6nniqs5g5zx";
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
