{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
  glibcLocales,
}:

buildPythonPackage rec {
  pname = "whichcraft";
  version = "0.6.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rNu5G2PWoV771kMNHXstNuRKcWl+k+Gbfe1Hev2fzoc=";
  };

  LC_ALL = "en_US.utf-8";
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
