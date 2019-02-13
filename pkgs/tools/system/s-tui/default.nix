{ stdenv, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "s-tui";
  version = "0.8.3";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "00lsh2v4i8rwfyjyxx5lijd6rnk9smcfffhzg5sv94ijpcnh216m";
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
