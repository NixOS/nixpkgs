# Taken from a past commit of nixpkgs

{ lib, buildPythonPackage, fetchPypi, pytest, glibcLocales, tox, pytest-cov, parso }:

buildPythonPackage rec {
  pname = "jedi";

  # TODO: Remove this package when version incompatibility issue with
  # python3Packages.jedi is resolved.
  #
  # Upstream requirements:
  # https://github.com/CoatiSoftware/SourcetrailPythonIndexer#requirements
  version = "0.17.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "86ed7d9b750603e4ba582ea8edc678657fb4007894a12bcf6f4bb97892f31d20";
  };

  checkInputs = [ pytest glibcLocales tox pytest-cov ];

  propagatedBuildInputs = [ parso ];

  checkPhase = ''
    LC_ALL="en_US.UTF-8" py.test test
  '';

  # tox required for tests: https://github.com/davidhalter/jedi/issues/808
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/davidhalter/jedi";
    description = "An autocompletion tool for Python that can be used for text editors";
    license = licenses.lgpl3Plus;
  };
}
