{ stdenv, fetchurl, buildPythonApplication, click, future, six }:

buildPythonApplication rec {
  name = "proselint-${version}";
  version = "0.9.0";

  doCheck = false; # fails to pass because it tries to run in home directory

  src = fetchurl {
    url = "mirror://pypi/p/proselint/${name}.tar.gz";
    sha256 = "1fibk24fx00bfn0z4iikcv519cz2nkcil9k187sf3adb2ldzg4ab";
  };

  propagatedBuildInputs = [ click future six ];

  meta = with stdenv.lib; {
    description = "A linter for prose";
    homepage = http://proselint.com;
    license = licenses.bsd3;
    maintainers = with maintainers; [ alibabzo ];
  };
}
