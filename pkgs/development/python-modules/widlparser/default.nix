{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  # build inputs
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "widlparser";
  version = "1.1.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "plinss";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-G5N29K0/ByfKwP1XfxZH9u/5x361JD/8qAD6eZaySnU=";
  };


  propagatedBuildInputs = [ typing-extensions ];

  pythonImportsCheck = [ "widlparser" ];

  meta = with lib; {
    description = "Stand-alone WebIDL Parser in Python";
    homepage = "https://github.com/plinss/widlparser";
    license = licenses.mit;
    maintainers = [ ];
  };
}
