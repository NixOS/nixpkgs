{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "tmuxp-${version}";
  version = "1.3.4";

  namePrefix = "";

  src = fetchurl {
    url = "mirror://pypi/t/tmuxp/${name}.tar.gz";
    sha256 = "149n35rr27n2c6yna1bla20x3w1zz9gxnjj3m3xxdfp4fbsd2y31";
  };

  patchPhase = ''
    sed -i 's/==.*$//' requirements/base.txt requirements/test.txt
  '';

  buildInputs = with pythonPackages; [
    pytest_29
    pytest-rerunfailures
  ];

  propagatedBuildInputs = with pythonPackages; [
    click colorama kaptan libtmux
  ];

  meta = with stdenv.lib; {
    description = "Manage tmux workspaces from JSON and YAML";
    homepage = http://tmuxp.readthedocs.io;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jgeerds ];
  };
}
