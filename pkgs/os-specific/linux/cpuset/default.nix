{ lib
, fetchFromGitHub
, fetchpatch
, pythonPackages
}:

pythonPackages.buildPythonApplication rec {
  pname = "cpuset";
  version = "1.6";

  propagatedBuildInputs = with pythonPackages; [
    configparser
    future
  ];

  # https://github.com/lpechacek/cpuset/pull/36
  patches = [
    (fetchpatch {
      url = "https://github.com/MawKKe/cpuset/commit/a4b6b275d0a43d2794ab9e82922d3431aeea9903.patch";
      sha256 = "1mi1xrql81iczl67s4dk2rm9r1mk36qhsa19wn7zgryf95krsix2";
    })
  ];

  makeFlags = [ "prefix=$(out)" ];

  src = fetchFromGitHub {
    owner = "lpechacek";
    repo = "cpuset";
    rev = "v${version}";
    sha256 = "0ig0ml2zd5542d0989872vmy7cs3qg7nxwa93k42bdkm50amhar4";
  };

  checkPhase = ''
    cd t
    make
  '';

  meta = with lib; {
    description = "Python application that forms a wrapper around the standard Linux filesystem calls to make using the cpusets facilities in the Linux kernel easier";
    homepage    = "https://github.com/lpechacek/cpuset";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ thiagokokada wykurz ];
    mainProgram = "cset";
  };
}
