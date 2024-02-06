{ lib
, git
, gnupg1
, python3Packages
, fetchPypi
}:

with python3Packages; buildPythonApplication rec {
  pname = "reno";
  version = "3.1.0";

  # Must be built from python sdist because of versioning quirks
  src = fetchPypi {
    inherit pname version;
    sha256 = "2510e3aae4874674187f88f22f854e6b0ea1881b77039808a68ac1a5e8ee69b6";
  };

  propagatedBuildInputs = [
    dulwich
    pbr
    pyyaml
    setuptools  # required for finding pkg_resources at runtime
  ];

  nativeCheckInputs = [
    # Python packages
    pytestCheckHook
    docutils
    fixtures
    sphinx
    testtools
    testscenarios

    # Required programs to run all tests
    git
    gnupg1
  ];

  # remove b/c doesn't list all dependencies, and requires a few packages not in nixpkgs
  postPatch = ''
    rm test-requirements.txt
  '';

  disabledTests = [
    "test_build_cache_db" # expects to be run from a git repository
  ];

  # verify executable
  postCheck = ''
    $out/bin/reno -h
  '';

  meta = with lib; {
    description = "Release Notes Manager";
    homepage = "https://docs.openstack.org/reno/latest";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger guillaumekoenig ];
  };
}
