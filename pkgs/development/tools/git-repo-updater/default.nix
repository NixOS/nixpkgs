{ lib, buildPythonApplication, fetchPypi
, colorama, GitPython }:

buildPythonApplication rec {
  pname = "gitup";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pa612rcc94nc461zs9sag9p46sycc214622b06gdn35rmwp0y2g";
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
