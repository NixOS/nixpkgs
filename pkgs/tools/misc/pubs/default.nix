{ stdenv, fetchFromGitHub, fetchpatch, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "pubs";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "pubs";
    repo = "pubs";
    rev = "v${version}";
    sha256 = "16zwdqfbmlla6906g3a57a4nj8wnl11fq78r20qms717bzv211j0";
  };

  patches = [
    # Fix for bibtexparser 1.1.0
    (fetchpatch {
      url = https://github.com/pubs/pubs/pull/185/commits/e58ae98b93b8364a07fd5f5f452ba88ad332c948.patch;
      sha256 = "1n7zrk119v395jj8wqg8wlymc9l9pq3v752yy3kam9kflc0aashp";
    })
    # Fix test broken by PyYAML 5.1
    (fetchpatch {
      url = https://github.com/pubs/pubs/pull/194/commits/c3cb713ae76528eeeaaeb948fe319a76ab3934d8.patch;
      sha256 = "05as418m7wzs65839bb91b2jrs8l68z8ldcjcd9cn4b9fcgsf3rk";
    })
  ];

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
