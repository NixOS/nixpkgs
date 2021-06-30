{ lib
, buildPythonPackage
, fetchPypi
, docutils
, sphinx
, readthedocs-sphinx-ext
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "sphinx_rtd_theme";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "32bd3b5d13dc8186d7a42fc816a23d32e83a4827d7d9882948e7b837c232da5a";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "docutils<0.17" "docutils"
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
