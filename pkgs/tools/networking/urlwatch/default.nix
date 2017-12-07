{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "urlwatch-${version}";
  version = "2.7";

  src = fetchFromGitHub {
    owner  = "thp";
    repo   = "urlwatch";
    rev    = version;
    sha256 = "0fx964z73yv08b1lpymmjsigf6929zx9ax5bp34rcf2c5gk11l5m";
  };

  propagatedBuildInputs = with python3Packages; [
    appdirs
    keyring
    minidb
    pyyaml
    pycodestyle
    requests
  ];

  meta = with stdenv.lib; {
    description = "A tool for monitoring webpages for updates";
    homepage = https://thp.io/2008/urlwatch/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ tv ];
  };
}
