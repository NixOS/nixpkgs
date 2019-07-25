{ stdenv, buildPythonApplication, fetchPypi }:
buildPythonApplication rec {
  version = "0.0.36";
  pname = "dazel";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10likhnbz5bg4bmlk8rzra9a2gyh0s7afj3gy7kgyvnlqkrvp5kv";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/nadirizr/dazel;
    description = "Run Google's bazel inside a docker container via a seamless proxy.";
    license = licenses.mit;
    maintainers = with maintainers; [
      q3k
    ];
  };
}
