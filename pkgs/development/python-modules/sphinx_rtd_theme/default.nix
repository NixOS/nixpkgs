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
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eec6d497e4c2195fa0e8b2016b337532b8a699a68bcb22a512870e16925c6a5c";
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
