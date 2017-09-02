{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "tmuxp-${version}";
  version = "1.3.1";

  namePrefix = "";

  src = fetchurl {
    url = "mirror://pypi/t/tmuxp/${name}.tar.gz";
    sha256 = "189mxnb2pxj3wjijn56j8y5x1r23fil00fn2q7d6bd13vgr0f85s";
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
