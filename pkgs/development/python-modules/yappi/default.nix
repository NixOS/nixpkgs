{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "yappi";
  version = "1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gs48c5sy771lsjhca3m4j8ljc6yhk5qnim3n5idnlaxa4ql30bz";
  };

  buildInputs = [ ];

  doCheck = false;

  meta = {
    homepage = https://github.com/sumerc/yappi;
    description = "yet another python profiler";
    maintainers = with lib.maintainers; [ mog ];
    license = lib.licenses.mit;
  };
}
