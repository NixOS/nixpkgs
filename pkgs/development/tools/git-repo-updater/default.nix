{ lib, buildPythonApplication, fetchPypi
, colorama, GitPython }:

buildPythonApplication rec {
  pname = "gitup";
  version = "0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11ilz9i2yxrbipyjzpfkj7drx9wkrn3phvd1a60jivphbqdldpgf";
  };

  propagatedBuildInputs = [ colorama GitPython ];

  meta = with lib; {
    description = "Easily update multiple Git repositories at once";
    homepage = "https://github.com/earwig/git-repo-updater";
    license = licenses.mit;
    maintainers = [ maintainers.bdesham ];
    platforms = platforms.all;
  };
}
