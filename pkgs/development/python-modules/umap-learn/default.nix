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
  version = "0.3.10";

  src = fetchFromGitHub {
    owner = "lmcinnes";
    repo = "umap";
    rev = version;
    sha256 = "0nck5va5km7qkbrhn15dsn0p2mms9kc641lcypy7l8haqgm44h8x";
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
    homepage = https://github.com/lmcinnes/umap;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
