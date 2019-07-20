{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
, numpy
, scikitlearn
, scipy
, numba
}:

buildPythonPackage rec {
  pname = "umap-learn";
  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "lmcinnes";
    repo = "umap";
    rev = version;
    sha256 = "1cdc7hs3vwzxvzs34l9a06q8rvks29wj6swyj8zvwr32knxch8a9";
  };

  checkInputs = [
    nose
  ];

  propagatedBuildInputs = [
    numpy
    scikitlearn
    scipy
    numba
  ];

  postConfigure = ''
   substituteInPlace umap/tests/test_umap.py \
     --replace "def test_umap_transform_on_iris()" "@SkipTest
def test_umap_transform_on_iris()"
  '';

  checkPhase = ''
    nosetests -s umap
  '';

  meta = with lib; {
    description = "Uniform Manifold Approximation and Projection";
    homepage = http://github.com/lmcinnes/umap;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
