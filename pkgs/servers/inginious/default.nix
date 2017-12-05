{ pkgs, lib, python2Packages }:
with lib;

let
  pythonPackages = python2Packages;

  docker_1_7_2 = pythonPackages.docker.overrideAttrs (oldAttrs: rec {
    name = "docker-py-1.7.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/d/docker-py/${name}.tar.gz";
      sha256 = "0k6hm3vmqh1d3wr9rryyif5n4rzvcffdlb1k4jvzp7g4996d3ccm";
    };
  });

  webpy-custom = pythonPackages.web.override {
    name = "web.py-INGI";
    src = pkgs.fetchFromGitHub {
      owner = "UCL-INGI";
      repo = "webpy-INGI";
      # tip of branch "ingi"
      rev = "f487e78d65d6569eb70003e588d5c6ace54c384f";
      sha256 = "159vwmb8554xk98rw380p3ah170r6gm861r1nqf2l452vvdfxscd";
    };
  };

in pythonPackages.buildPythonApplication rec {
  version = "0.3a2.dev0";
  name = "inginious-${version}";

  disabled = pythonPackages.isPy3k;

  patchPhase = ''
    # transient failures
    substituteInPlace inginious/backend/tests/TestRemoteAgent.py \
      --replace "test_update_task_directory" "noop"
  '';

  propagatedBuildInputs = with pythonPackages; [
    requests
    cgroup-utils docker_1_7_2 docutils PyLTI mock pygments
    pymongo pyyaml rpyc sh simpleldap sphinx_rtd_theme tidylib
    websocket_client watchdog webpy-custom flup
  ];

  buildInputs = with pythonPackages; [ nose selenium virtual-display ];

  /* Hydra fix exists only on github for now.
  src = pkgs.fetchurl {
    url = "mirror://pypi/I/INGInious/INGInious-${version}.tar.gz";
  };
  */
  src = pkgs.fetchFromGitHub {
    owner = "UCL-INGI";
    repo = "INGInious";
    rev = "07d111c0a3045c7cc4e464d4adb8aa28b75a6948";
    sha256 = "0kldbkc9yw1mgg5w5q5v8k2hz089c5c4rvxb5xhbagkzgm2gn230";
  };

  # Only patch shebangs in /bin, other scripts are run within docker
  # containers and will fail if patched.
  dontPatchShebangs = true;
  preFixup = ''
    patchShebangs $prefix/bin
  '';

  meta = {
    description = "An intelligent grader that allows secured and automated testing of code made by students";
    homepage = https://github.com/UCL-INGI/INGInious;
    license = licenses.agpl3;
    maintainers = with maintainers; [ layus ];
  };
}
