{ stdenv
, fetchFromGitHub
, python2Packages
}:

python2Packages.buildPythonApplication rec {
  pname = "cpuset";
  version = "1.5.8";

  propagatedBuildInputs = [ ];

  makeFlags = [ "prefix=$(out)" ];

  src = fetchFromGitHub {
    owner = "wykurz";
    repo = "cpuset";
    rev = "v${version}";
    sha256 = "19fl2sn470yrnm2q508giggjwy5b6r2gd94gvwfbdlhf0r9dsbbm";
  };

  meta = with stdenv.lib; {
    description = "Cpuset is a Python application that forms a wrapper around the standard Linux filesystem calls to make using the cpusets facilities in the Linux kernel easier.";
    homepage    = "https://github.com/wykurz/cpuset";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ wykurz ];
  };
}
