{ stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  version = "1.1.5";
  pname = "wllvm";
  name = "${pname}-${version}";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "02lnilhqz7mq0w6mp574rmjxiszp1wyla16jqr89r0z9vjg2j9rv";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/travitch/whole-program-llvm;
    description = "A wrapper script to build whole-program LLVM bitcode files";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.all;
  };
}
