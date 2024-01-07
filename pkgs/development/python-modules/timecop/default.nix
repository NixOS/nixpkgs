{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "timecop";
  version = "0.5.0dev";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zbi58sw2yp1qchzfhyi7bsrwxajiypphg65fir98kvj03g011wd";
  };

  # test_epoch fails, see https://github.com/bluekelp/pytimecop/issues/4
  preCheck = ''
    sed -i 's/test_epoch/_test_epoch/' timecop/tests/test_freeze.py
  '';

  meta = with lib; {
    description = "A port of the most excellent TimeCop Ruby Gem for Python";
    homepage = "https://github.com/bluekelp/pytimecop";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ zakame ];
  };
}
