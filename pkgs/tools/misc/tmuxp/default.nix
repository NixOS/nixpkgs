{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "tmuxp-${version}";
  version = "1.2.2";

  namePrefix = "";

  src = fetchurl {
    url = "mirror://pypi/t/tmuxp/${name}.tar.gz";
    sha256 = "1g37pdxs0wmnskqm7qsqm0ygwpc1dxk1d7lrzpgs717zxaak8vln";
  };

  patchPhase = ''
    sed -i 's/==.*$//' requirements/test.txt
  '';

  buildInputs = with pythonPackages; [
    pytest
    pytest-rerunfailures
  ];

  propagatedBuildInputs = with pythonPackages; [
    click colorama kaptan libtmux
  ];

  meta = with stdenv.lib; {
    description = "Manage tmux workspaces from JSON and YAML";
    homepage = "http://tmuxp.readthedocs.io";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jgeerds ];
  };
}
