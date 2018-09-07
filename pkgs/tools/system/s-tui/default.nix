{ stdenv, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "s-tui";
  version = "0.7.5";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "01w5jh0p66jk4h3cmif4glq42zv44zhziczxjwazkd034rp8dnv9";
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
