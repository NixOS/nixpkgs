{ lib, buildPythonPackage, fetchPypi, pytest, glibcLocales }:

buildPythonPackage rec {
  pname = "whichcraft";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1614vs0iwm9abina70vgvxaabi8xbz83yxgqfqi1syrzrhaalk6m";
  };

  LC_ALL="en_US.utf-8";
  buildInputs = [ glibcLocales ];

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    homepage = https://github.com/pydanny/whichcraft;
    description = "Cross-platform cross-python shutil.which functionality";
    license = licenses.bsd3;
  };
}
