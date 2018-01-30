{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "urlwatch-${version}";
  version = "2.8";

  src = fetchFromGitHub {
    owner  = "thp";
    repo   = "urlwatch";
    rev    = version;
    sha256 = "1nja7n6pc45azd3l1xyvav89855lvcgwabrvf34rps81dbl8cnl4";
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
