{ stdenv, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "s-tui";
  version = "1.0.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0r5yhlsi5xiy7ii1w4kqkaxz9069v5bbfwi3x3xnxhk51yjfgr8n";
  };

  propagatedBuildInputs = with python3Packages; [
    urwid
    psutil
  ];

  LC_ALL = "en_US.UTF-8";

  meta = with stdenv.lib; {
    homepage = https://amanusk.github.io/s-tui/;
    description = "Stress-Terminal UI monitoring tool";
    license = licenses.gpl2;
    maintainers = with maintainers; [ infinisil ];
  };
}
