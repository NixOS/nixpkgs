{ python3, glibcLocales, lib }:

with python3.pkgs;

buildPythonApplication rec {
  version = "0.4.1";
  pname = "ghp-import";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6058810e1c46dd3b5b1eee87e203bdfbd566e10cfc77566edda7aa4dbf6a3053";
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
