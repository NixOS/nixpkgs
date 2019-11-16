{ stdenv, buildPythonPackage, fetchPypi, jinja2, flake8 }:

buildPythonPackage rec {
  pname = "swagger-ui-bundle";
  version = "0.0.5";

  src = fetchPypi {
    pname = "swagger_ui_bundle";
    inherit version;
    sha256 = "0v69v94mzzb63ciwpz3n8jwxqcyll3fsyx087s9k9q543zdqzbh1";
  };

  # patch away unused test requirements since package contains no tests
  postPatch = ''
    substituteInPlace setup.py --replace "setup_requires=['pytest-runner', 'flake8']" "setup_requires=[]"
  '';

  propagatedBuildInputs = [ jinja2 ];

  # package contains no tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "bundled swagger-ui pip package";
    homepage = https://github.com/dtkav/swagger_ui_bundle;
    license = licenses.asl20;
    maintainers = with maintainers; [ elohmeier ];
  };
}
