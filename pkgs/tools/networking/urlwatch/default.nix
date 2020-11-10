{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "urlwatch-${version}";
  version = "2.19";

  src = fetchFromGitHub {
    owner  = "thp";
    repo   = "urlwatch";
    rev    = version;
    sha256 = "05vxs0x8gnsv2r9cy0brqny1y5jnj2mw11lqc8lqahx84xcs2m00";
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
