{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "stringly";
  version = "1.0b3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "evalf";
    repo = "stringly";
    tag = "v${version}";
    hash = "sha256-OAATONkok9M2pVoChtwWMPPU/bhAxGf+BFawy9g3iZI=";
  };

  build-system = [ flit-core ];

  dependencies = [ typing-extensions ];

  pythonImportsCheck = [ "stringly" ];

  doCheck = false; # no tests

  meta = with lib; {
    description = "Stringly: Human Readable Object Serialization";
    homepage = "https://github.com/evalf/stringly";
    license = licenses.mit;
    maintainers = [ maintainers.Scriptkiddi ];
  };
}
