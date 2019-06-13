{ lib, python3, glibcLocales }:

python3.pkgs.buildPythonApplication rec {
  pname = "csvkit";
  version = "1.0.4";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "1830lb95rh1iyi3drlwxzb6y3pqkii0qiyzd40c1kvhvaf1s6lqk";
  };

  propagatedBuildInputs = with python3.pkgs; [
    agate agate-excel agate-dbf agate-sql six
  ];

  checkInputs = with python3.pkgs; [
    glibcLocales nose
  ];

  checkPhase = ''
    LC_ALL="en_US.UTF-8" nosetests -e test_csvsql
  '';

  meta = with lib; {
    description = "A suite of command-line tools for converting to and working with CSV";
    maintainers = with maintainers; [ vrthra ];
    license = licenses.mit;
    homepage = https://github.com/wireservice/csvkit;
  };
}
