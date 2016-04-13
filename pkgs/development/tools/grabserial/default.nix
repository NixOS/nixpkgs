{ stdenv, fetchgit, buildPythonApplication, pythonPackages }:

buildPythonApplication rec {

  name = "grabserial-20141120";
  namePrefix = "";

  src = fetchgit {
    url = https://github.com/tbird20d/grabserial.git;
    rev  = "8b9c98ea35d382bac2aafc7a8a9c02440369a792";
    sha256 = "ff27f5e5ab38c8450a4a0291e943e6c5a265e56d29d6a1caa849ae3238d71679";
  };

  propagatedBuildInputs = [ pythonPackages.pyserial ];

  meta = {
    description = "Python based serial dump and timing program";
    homepage = https://github.com/tbird20d/grabserial;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ vmandela ];
    platforms = stdenv.lib.platforms.linux;
  };
}
