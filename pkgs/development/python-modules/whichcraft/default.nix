{ lib, buildPythonPackage, fetchPypi, pytest, glibcLocales }:

buildPythonPackage rec {
  pname = "whichcraft";
  version = "0.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11yfkzyplizdgndy34vyd5qlmr1n5mxis3a3svxmx8fnccdvknxc";
  };

  LC_ALL="en_US.utf-8";
  buildInputs = [ glibcLocales ];

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    homepage = "https://github.com/pydanny/whichcraft";
    description = "Cross-platform cross-python shutil.which functionality";
    license = licenses.bsd3;
  };
}
