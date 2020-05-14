{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "urlwatch-${version}";
  version = "2.18";

  src = fetchFromGitHub {
    owner  = "thp";
    repo   = "urlwatch";
    rev    = version;
    sha256 = "14dmyk95v3kajhn1w2lpil3rjs78y0wxylsxclv6zjxgjcc1xsi3";
  };

  propagatedBuildInputs = with python3Packages; [
    appdirs
    cssselect
    keyring
    lxml
    minidb
    pycodestyle
    pyyaml
    requests
  ];

  meta = with stdenv.lib; {
    description = "A tool for monitoring webpages for updates";
    homepage = "https://thp.io/2008/urlwatch/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ tv ];
  };
}
