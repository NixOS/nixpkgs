{ stdenv, buildPythonPackage, fetchPypi, pbr, six }:

buildPythonPackage rec {
  pname = "tenacity";
  version = "5.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4c10be4f8fbeb1cae24b9315103d8aca3f2b1ef001d455cbb1671d3d79924be6";
  };

  propagatedBuildInputs = [ pbr six ];

  # does not work due missing secrets file
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/jd/tenacity;
    description = "Retrying library for Python";
    license = licenses.asl20;
    maintainers = with maintainers; [ poelzi ];
  };
}
