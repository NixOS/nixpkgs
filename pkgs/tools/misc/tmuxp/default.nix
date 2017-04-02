{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "tmuxp-${version}";
  version = "1.2.7";

  namePrefix = "";

  src = fetchurl {
    url = "mirror://pypi/t/tmuxp/${name}.tar.gz";
    sha256 = "19s17frgyjvyvmr16fs0gl5mnbaxbmdffmkckadwhd5mg0pz2i4s";
  };

  patchPhase = ''
    sed -i 's/==.*$//' requirements/test.txt
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
    homepage = "http://tmuxp.readthedocs.io";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jgeerds ];
  };
}
