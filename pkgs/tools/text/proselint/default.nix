{ lib, fetchurl, buildPythonApplication, click, future, six }:

buildPythonApplication rec {
  pname = "proselint";
  version = "0.12.0";

  doCheck = false; # fails to pass because it tries to run in home directory

  src = fetchurl {
    url = "mirror://pypi/p/proselint/${pname}-${version}.tar.gz";
    sha256 = "2a98d9c14382d94ed9122a6c0b0657a814cd5c892c77d9477309fc99f86592e6";
  };

  propagatedBuildInputs = [ click future six ];

  meta = with lib; {
    description = "A linter for prose";
    homepage = "http://proselint.com";
    license = licenses.bsd3;
    maintainers = with maintainers; [ alibabzo ];
  };
}
