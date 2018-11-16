{ stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  version = "1.2.2";
  pname = "wllvm";
  name = "${pname}-${version}";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1zrjcabv41105mmv632gp488kmhya37n0jwgwxhadps4z3jv2qxb";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/travitch/whole-program-llvm;
    description = "A wrapper script to build whole-program LLVM bitcode files";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 dtzWill ];
    platforms = platforms.all;
  };
}
