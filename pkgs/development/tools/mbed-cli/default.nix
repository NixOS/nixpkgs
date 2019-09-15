{ lib, python3Packages, git, mercurial, substituteAll }:

with python3Packages;

buildPythonApplication rec {
  pname = "mbed-cli";
  version = "1.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d26rbsyx813i025wmppf020wab1ik20ndi4alnrkp2wzjb59p9n";
  };

  nativeBuildInputs = [
    git
    mercurial
  ];

  propagatedBuildInputs = [
    mbed-os-tools
    pip
    pyserial

    # Some of mbed-os dependencies.
    # `mbed update -v` still fails with:
    #   [mbed] ERROR: Missing Python modules were not auto-installed.
    #     The Mbed OS tools in this program require the following Python modules: mbed_cloud_sdk, mbed_ls, mbed_host_tests, mbed_greentea, manifest_tool, icetea, cmsis_pack_manager
    #     You can install all missing modules by running "pip install -r requirements.txt" in "/tmp/test-mbed/mbed-os"
    #     On Posix systems (Linux, etc) you might have to switch to superuser account or use "sudo"
    click
    jinja2
    jsonschema
    psutil
    pycryptodome
    pyelftools
    pyusb
    pyyaml
  ];

  checkInputs = [
    git
    mercurial
    pytest
  ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit mercurial git;
      python = python.withPackages(ps: propagatedBuildInputs);
    })
  ];

  checkPhase = ''
    export GIT_COMMITTER_NAME=nixbld
    export EMAIL=nixbld@localhost
    export GIT_COMMITTER_DATE=$SOURCE_DATE_EPOCH
    pytest test
  '';

  meta = with lib; {
    homepage = https://github.com/ARMmbed/mbed-cli;
    description = "Arm Mbed Command Line Interface";
    license = licenses.asl20;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}

