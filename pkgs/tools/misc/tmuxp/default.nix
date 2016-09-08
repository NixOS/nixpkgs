{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "tmuxp-${version}";
  version = "1.2.0";

  namePrefix = "";

  src = fetchurl {
    url = "mirror://pypi/t/tmuxp/${name}.tar.gz";
    sha256 = "05z5ssv9glsqmcy9fdq06bawy1274dnzqsqd3a4z4jd0w6j09smn";
  };

  buildInputs = with pythonPackages; [ pytest ];

  propagatedBuildInputs = with pythonPackages; [
    click colorama kaptan libtmux
  ];

  meta = with stdenv.lib; {
    description = "Manage tmux workspaces from JSON and YAML";
    homepage = "http://tmuxp.readthedocs.io";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jgeerds ];
  };
}
