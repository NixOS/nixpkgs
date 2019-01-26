{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "pubs";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "pubs";
    repo = "pubs";
    rev = "v${version}";
    sha256 = "16zwdqfbmlla6906g3a57a4nj8wnl11fq78r20qms717bzv211j0";
  };

  propagatedBuildInputs = with python3Packages; [
    argcomplete dateutil configobj feedparser bibtexparser pyyaml requests six beautifulsoup4
  ];

  checkInputs = with python3Packages; [ pyfakefs mock ddt ];

  meta = with stdenv.lib; {
    description = "Command-line bibliography manager";
    homepage = https://github.com/pubs/pubs;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ gebner ];
  };
}
