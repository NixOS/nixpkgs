{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "urlwatch-${version}";
  version = "2.13";

  src = fetchFromGitHub {
    owner  = "thp";
    repo   = "urlwatch";
    rev    = version;
    sha256 = "0rspb5j02mmb0r2dnfryx7jaczvb22lsnysgrr1l9iag0djcgdf5";
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
