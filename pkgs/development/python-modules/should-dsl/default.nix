{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "should-dsl";
  version = "2.1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "should_dsl";
    hash = "sha256-NvdT2Q+9+E7yt6ngeBPj76xyU3b+t6eTVJ8//3oDIyo=";
  };

  # There are no tests
  doCheck = false;

  meta = with lib; {
    description = "Should assertions in Python as clear and readable as possible";
    homepage = "http://www.should-dsl.info/";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
