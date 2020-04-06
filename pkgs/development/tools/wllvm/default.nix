{ stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  version = "1.2.8";
  pname = "wllvm";
  name = "${pname}-${version}";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1d88fzg4ba4r3hwrinnv6agiyj3xxdy4yryb8wz2ml51nc6bi591";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/travitch/whole-program-llvm";
    description = "A wrapper script to build whole-program LLVM bitcode files";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 dtzWill ];
    platforms = platforms.all;
  };
}
