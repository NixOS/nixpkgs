{ stdenv, fetchgit, pythonPackages }:

pythonPackages.buildPythonApplication rec {

  name = "grabserial-1.9.3";
  namePrefix = "";

  src = fetchgit {
    url = https://github.com/tbird20d/grabserial.git;
    rev  = "7cbf104b61ffdf68e6782a8e885050565399a014";
    sha256 = "043r2p5jw0ymx8ka1d39q1ap39i7sliq5f4w3yr1n53lzshjmc5g";
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
