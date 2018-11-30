{ stdenv, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "s-tui";
  version = "0.8.2";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "18bn0bpnrljx11gj95m2x5hlsnb8jkivlm6b1xx035ldgj1svgzh";
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
