{ python3, glibcLocales, lib }:

with python3.pkgs;

buildPythonApplication rec {
  version = "0.5.5";
  pname = "ghp-import";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mvmpi7lqflw2lr0g0y5f9s0d1pv9cav4gbmaqnziqg442klx4iy";
  };

  disabled = isPyPy;
  buildInputs = [ glibcLocales ];

  LC_ALL="en_US.UTF-8";

  # No tests available
  doCheck = false;

  meta = {
    description = "Copy your docs directly to the gh-pages branch";
    homepage = "https://github.com/davisp/ghp-import";
    license = "Tumbolia Public License";
    maintainers = with lib.maintainers; [ garbas ];
  };
}
