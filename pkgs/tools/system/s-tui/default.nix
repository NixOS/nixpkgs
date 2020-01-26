{ stdenv, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  pname = "s-tui";
  version = "1.0.0";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "0r5yhlsi5xiy7ii1w4kqkaxz9069v5bbfwi3x3xnxhk51yjfgr8n";
  };

  propagatedBuildInputs = with pythonPackages; [
    urwid
    psutil
  ];

  meta = with stdenv.lib; {
    homepage = https://amanusk.github.io/s-tui/;
    description = "Stress-Terminal UI monitoring tool";
    license = licenses.gpl2;
    maintainers = with maintainers; [ infinisil ];
  };
}
