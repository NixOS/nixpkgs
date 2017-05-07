{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "urlwatch-${version}";
  version = "2.5";

  src = fetchFromGitHub {
    owner  = "thp";
    repo   = "urlwatch";
    rev    = version;
    sha256 = "0irz54nvyq3cxa3fvjc5k2836a5nmly4wiiy4s5cwib1rnwg6r94";
  };

  propagatedBuildInputs = with python3Packages; [
    keyring
    minidb
    pyyaml
    requests
  ];

  meta = with stdenv.lib; {
    description = "A tool for monitoring webpages for updates";
    homepage = https://thp.io/2008/urlwatch/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ tv ];
  };
}
