{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "urlwatch-${version}";
  version = "2.9";

  src = fetchFromGitHub {
    owner  = "thp";
    repo   = "urlwatch";
    rev    = version;
    sha256 = "0biy02vyhdwghy9qjmjwlfd8hzaz9gfsssd53ng6zpww4wkkiydz";
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
