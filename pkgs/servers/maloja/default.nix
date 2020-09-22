{ stdenv, lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "malojaserver";
  version = "2.14.6";
  format = "wheel";

  #src = fetchFromGitHub {
  #  owner = "krateng";
  #  repo = "maloja";
  #  rev = "v${version}";
  #  sha256 = "sha256-i/J9iRdcOh0ttXU+nSbsiJUkobkrEEnWHxXCNcJe1kQ=";
  #};
  src = python3Packages.fetchPypi {
    inherit pname version format;
    dist = "py3";
    python = "py3";
    sha256 = "sha256-Gd+UMOU9oDhzjpaoAKHio/6Wnl/OrnYqBHXmjkhhhII=";
  };

  propagatedBuildInputs = with python3Packages; [
    css-html-js-minify
    doreah
    lru-dict
    nimrodel
    setproctitle
    psutil
  ];

  meta = with lib; {
    description = "Self-hosted music scrobble database to create personal listening statistics and charts";
    homepage    = "https://github.com/krateng/maloja";
    license     = with licenses; [gpl3];
    maintainers = with maintainers; [ sohalt ];
    platforms   = platforms.unix;
  };
}
