{ lib, buildPythonPackage, fetchPypi, jinja2, flake8 }:

buildPythonPackage rec {
  pname = "swagger-ui-bundle";
  version = "0.0.9";
  format = "setuptools";

  src = fetchPypi {
    pname = "swagger_ui_bundle";
    inherit version;
    sha256 = "b462aa1460261796ab78fd4663961a7f6f347ce01760f1303bbbdf630f11f516";
  };

  # patch away unused test requirements since package contains no tests
  postPatch = ''
    substituteInPlace setup.py --replace "setup_requires=['pytest-runner', 'flake8']" "setup_requires=[]"
  '';

  propagatedBuildInputs = [ jinja2 ];

  # package contains no tests
  doCheck = false;

  meta = with lib; {
    description = "bundled swagger-ui pip package";
    homepage = "https://github.com/dtkav/swagger_ui_bundle";
    license = licenses.asl20;
    maintainers = with maintainers; [ elohmeier ];
  };
}
