{ fetchurl, boost, zlib, clang, ncurses, pythonPackages, lib }:

pythonPackages.buildPythonPackage rec {
  pname = "vowpalwabbit";
  name = "${pname}-${version}";
  version = "8.3.2";

  src = fetchurl{
    url = "mirror://pypi/v/vowpalwabbit/${name}.tar.gz";
    sha256 = "0qm8rlrs2gfgamqnpx4lapxakpzgh0yh3kp1lbd7lhb0r748m3k7";
  };
  # vw tries to write some explicit things to home
  # python installed: The directory '/homeless-shelter/.cache/pip/http'
  preInstall = ''
    export HOME=$PWD
  '';

  buildInputs = with pythonPackages; [ boost.dev zlib.dev clang ncurses pytest docutils pygments ];
  propagatedBuildInputs = with pythonPackages; [ numpy scipy scikitlearn ];

  checkPhase = ''
    # check-manifest requires a git clone, not a tarball
    # check-manifest --ignore "Makefile,PACKAGE.rst,*.cc,tox.ini,tests*,examples*,src*"
    python setup.py check -mrs
  '';

  meta = with lib; {
    description = "Vowpal Wabbit is a fast machine learning library for online learning, and this is the python wrapper for the project.";
    homepage    = https://github.com/JohnLangford/vowpal_wabbit;
    license     = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
  };
}
