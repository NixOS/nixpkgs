{ stdenv, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "s-tui";
  version = "0.6.2";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "0fijk26sm51bnxf7plzd1fn2k4f8mdqd7j9zqc3d8zri7228vik2";
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
