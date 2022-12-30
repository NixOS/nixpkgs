{ lib
, buildPythonPackage
, fetchPypi
, docutils
, sphinx
, readthedocs-sphinx-ext
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "sphinx-rtd-theme";
  version = "1.1.1";

  src = fetchPypi {
    pname = "sphinx_rtd_theme";
    inherit version;
    sha256 = "sha256-YUbIRfHhlHs8PdRDLCiZihaTzMdCtPmtfGMSnwdXwQM=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "docutils<0.18" "docutils"
  '';

  preBuild = ''
    # Don't use NPM to fetch assets. Assets are included in sdist.
    export CI=1
  '';

  propagatedBuildInputs = [
    docutils
    sphinx
  ];

  checkInputs = [
    readthedocs-sphinx-ext
    pytestCheckHook
  ];

  meta = with lib; {
    description = "ReadTheDocs.org theme for Sphinx";
    homepage = "https://github.com/readthedocs/sphinx_rtd_theme";
    license = licenses.mit;
    platforms = platforms.unix;
  };

}
