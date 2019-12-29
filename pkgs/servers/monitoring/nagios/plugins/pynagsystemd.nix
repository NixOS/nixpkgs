{ fetchFromGitHub, python3Packages, lib }:

python3Packages.buildPythonApplication rec {
  pname = "pynagsystemd";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "kbytesys";
    repo = pname;
    rev = "v${version}";
    sha256 = "1xjhkhdpmqa7ngcpcfhrkmj4cid2wla3fzgr04wvw672ysffv2vz";
  };

  propagatedBuildInputs = with python3Packages; [ nagiosplugin ];

  meta = with lib; {
    description = "Simple and easy nagios check for systemd status";
    homepage = "https://github.com/kbytesys/pynagsystemd";
    maintainers = with maintainers; [ symphorien ];
    license = licenses.gpl2;
  };
}
