{ stdenv, python2Packages }:

with python2Packages;
buildPythonApplication rec {
  pname = "lit";
  version = "0.5";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3ea4251e78ebeb2e07be2feb33243d1f8931d956efc96ccc2b0846ced212b58c";
  };

  meta = {
    description = "Portable tool for executing LLVM and Clang style test suites";
    homepage = "http://llvm.org/docs/CommandGuide/lit.html";
    license = licenses.ncsa;
    maintainers = with maintainers; [ dtzWill ];
  };
}
