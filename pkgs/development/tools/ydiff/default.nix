{ stdenv, lib, pythonPackages, python3Packages, less, patchutils, git
, subversion, coreutils, which }:

with pythonPackages;

buildPythonApplication rec {
  pname = "ydiff";
  version = "1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mxcl17sx1d4vaw22ammnnn3y19mm7r6ljbarcjzi519klz26bnf";
  };

  patchPhase = ''
    substituteInPlace tests/test_ydiff.py \
      --replace /bin/rm ${coreutils}/bin/rm \
      --replace /bin/sh ${stdenv.shell}
    substituteInPlace Makefile \
      --replace "pep8 --ignore" "# pep8 --ignore" \
      --replace "python3 \`which coverage\`" "${python3Packages.coverage}/bin/coverage3" \
      --replace /bin/sh ${stdenv.shell} \
      --replace tests/regression.sh "${stdenv.shell} tests/regression.sh"
    patchShebangs tests/*.sh
  '';

  buildInputs = [ docutils pygments ];
  propagatedBuildInputs = [ less patchutils ];
  checkInputs = [ coverage coreutils git subversion which ];

  checkTarget = if isPy3k then "test3" else "test";

  meta = {
    homepage = https://github.com/ymattw/ydiff;
    description = "View colored, incremental diff in workspace or from stdin";
    longDescription = ''
      Term based tool to view colored, incremental diff in a version
      controlled workspace (supports Git, Mercurial, Perforce and Svn
      so far) or from stdin, with side by side (similar to diff -y)
      and auto pager support.
    '';
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ leenaars ];
  };
}
