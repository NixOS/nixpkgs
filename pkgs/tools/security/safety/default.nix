{ stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "safety";
  version = "1.8.5";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0y6b4j7wa52xh9q5f8qibc4azgsv801p977a902k6j1nmgzz6nah";
  };

  # Inpure tests, as they require internet connection
  doCheck = false;

  propagatedBuildInputs = with python3Packages; [
    dparse
    requests
    click
    pyyaml
    setuptools
  ];

  meta = with stdenv.lib; {
    description = "Safety checks your installed dependencies for known security vulnerabilities";
    homepage = "https://pyup.io/safety/";
    license = licenses.gpl3;
    maintainers = [ maintainers.mmahut ];
  };
}
