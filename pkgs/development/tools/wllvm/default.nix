{ stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  version = "1.1.3";
  pname = "wllvm";
  name = "${pname}-${version}";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1scv9bwr888x2km8njg0000xkj8pz73c0gjbphhqaj8vy87y25cb";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/travitch/whole-program-llvm;
    description = "A wrapper script to build whole-program LLVM bitcode files";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.all;
  };
}
