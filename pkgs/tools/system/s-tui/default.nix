{ stdenv, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "s-tui";
  version = "1.0.1";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1gqrb2xxii43j7kszy7kvv4f6hr8ac4p0m9q8i1xs5fhsqcx186i";
  };

  propagatedBuildInputs = with python3Packages; [
    urwid
    psutil
  ];

  LC_ALL = "en_US.UTF-8";

  meta = with stdenv.lib; {
    homepage = "https://amanusk.github.io/s-tui/";
    description = "Stress-Terminal UI monitoring tool";
    license = licenses.gpl2;
    maintainers = with maintainers; [ infinisil ];
  };
}
