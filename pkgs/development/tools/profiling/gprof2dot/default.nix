{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication {
  name = "gprof2dot-2015-04-27";

  src = fetchFromGitHub {
    owner = "jrfonseca";
    repo = "gprof2dot";
    rev = "6fbb81559609c12e7c64ae5dce7d102a414a7514";
    sha256 = "1fff7w6dm6lld11hp2ij97f85ma1154h62dvchq19c5jja3zjw3c";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/jrfonseca/gprof2dot;
    description = "Python script to convert the output from many profilers into a dot graph";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
  };
}
