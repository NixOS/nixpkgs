{ stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  version = "1.2.0";
  pname = "wllvm";
  name = "${pname}-${version}";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1hriyv5gfkcxjqk71l3030qfy3scsjr3mp12hkxfknh65inlqs5z";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/travitch/whole-program-llvm;
    description = "A wrapper script to build whole-program LLVM bitcode files";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.all;
  };
}
