{ lib
, buildPythonPackage
, fetchPypi
, isPy27
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-serializinghtml";
  version = "1.1.5";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "aa5f6de5dfdf809ef505c4895e51ef5c9eac17d0f287933eb49ec495280b6952";
  };

  # Check is disabled due to circular dependency of sphinx
  doCheck = false;

  meta = with lib; {
    description = "sphinxcontrib-serializinghtml is a sphinx extension which outputs \"serialized\" HTML files (json and pickle).";
    homepage = "https://github.com/sphinx-doc/sphinxcontrib-serializinghtml";
    license = licenses.bsd0;
    maintainers = teams.sphinx.members;
  };
}
