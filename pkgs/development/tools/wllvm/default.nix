{ stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  version = "1.2.1";
  pname = "wllvm";
  name = "${pname}-${version}";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1yr0gijhgbxx1sl5a8dygr3a8g5wfkh9rk4v789r2aplvcbanv5a";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/travitch/whole-program-llvm;
    description = "A wrapper script to build whole-program LLVM bitcode files";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 dtzWill ];
    platforms = platforms.all;
  };
}
