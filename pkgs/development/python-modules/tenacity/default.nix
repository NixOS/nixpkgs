{ lib, fetchPypi, buildPythonPackage, isPy3k
# buildInputs
, pbr
, futures
, six
, monotonic
# checkInputs
, tornado
}:

# tenacity = callPackage ../development/python-modules/tenacity {};
buildPythonPackage rec {
  pname = "tenacity";
  version = "4.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nslcna0vy75mk5rc1s9kjzvwys5zk79fq4lmk23vn5g4r7gdqk7";
  };

  propagatedBuildInputs = [
    pbr
    futures
    six
    monotonic
  ];

  checkInputs = [
    tornado
  ];

  # async is unsupported by py2
  preCheck = lib.optionalString (!isPy3k) "rm  tenacity/tests/test_async.py";

  meta = with lib; {
    description = "Retry code until it succeeeds";
    homepage = "https://github.com/jd/tenacity";
    license = licenses.asl20;
    maintainers = with maintainers; [  ];
  };
}
