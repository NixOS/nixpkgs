{ lib, python3, glibcLocales }:

python3.pkgs.buildPythonApplication rec {
  pname = "csvkit";
  version = "1.0.5";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "1ffmbzk4rxnl1yhqfl58v7kvl5m9cbvjm8v7xp4mvr00sgs91lvv";
  };

  propagatedBuildInputs = with python3.pkgs; [
    agate
    agate-excel
    # dbf test fail with agate-dbf-0.2.2
    (agate-dbf.overridePythonAttrs(old: rec {
      version = "0.2.1";
      src = python3.pkgs.fetchPypi {
        inherit (old) pname;
        inherit version;
        sha256 = "0brprva3vjypb5r9lk6zy10jazp681rxsqxzhz2lr869ir4krj80";
      };}))
    # sql test fail with agate-sql-0.5.4
    (agate-sql.overridePythonAttrs(old: rec {
      version = "0.5.3";
      src = python3.pkgs.fetchPypi {
        inherit (old) pname;
        inherit version;
        sha256 = "1d6rbahmdix7xi7ma2v86fpk5yi32q5dba5vama35w5mmn2pnyw7";
      };}))
    six
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
    homepage = "https://github.com/wireservice/csvkit";
  };
}
