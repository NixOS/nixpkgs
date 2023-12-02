{ lib, buildPythonPackage, fetchPypi, jinja2, flake8 }:

buildPythonPackage rec {
  pname = "swagger-ui-bundle";
  version = "1.1.0";

  src = fetchPypi {
    pname = "swagger_ui_bundle";
    inherit version;
    sha256 = "sha256-IGc8NDHIcz1dFhXs952azzDP91ICrK8hp9nH9IlxRSk=";
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
