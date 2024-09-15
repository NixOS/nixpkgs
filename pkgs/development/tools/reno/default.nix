{
  lib,
  fetchPypi,
  git,
  gnupg1,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "reno";
  version = "4.1.0";
  pyproject = true;

  # Must be built from python sdist because of versioning quirks
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+ZLx/b0WIV7J3kevCBMdU6KDDJ54Q561Y86Nan9iU3A=";
  };

  # remove b/c doesn't list all dependencies, and requires a few packages not in nixpkgs
  postPatch = ''
    rm test-requirements.txt
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    dulwich
    pbr
    pyyaml
    setuptools  # required for finding pkg_resources at runtime
  ];

  nativeCheckInputs = with python3Packages; [
    # Python packages
    docutils
    fixtures
    sphinx
    stestr
    testtools
    testscenarios

    # Required programs to run all tests
    git
    gnupg1
  ];

  checkPhase = ''
    runHook preCheck
    export HOME=$TMPDIR
    stestr run -e <(echo "
      # Expects to be run from a git repository
      reno.tests.test_cache.TestCache.test_build_cache_db
      reno.tests.test_semver.TestSemVer.test_major_post_release
      reno.tests.test_semver.TestSemVer.test_major_working_and_post_release
      reno.tests.test_semver.TestSemVer.test_major_working_copy
      reno.tests.test_semver.TestSemVer.test_minor_post_release
      reno.tests.test_semver.TestSemVer.test_minor_working_and_post_release
      reno.tests.test_semver.TestSemVer.test_minor_working_copy
      reno.tests.test_semver.TestSemVer.test_patch_post_release
      reno.tests.test_semver.TestSemVer.test_patch_working_and_post_release
      reno.tests.test_semver.TestSemVer.test_patch_working_copy
      reno.tests.test_semver.TestSemVer.test_same
      reno.tests.test_semver.TestSemVer.test_same_with_note
    ")
    runHook postCheck
  '';

  pythonImportsCheck = [ "reno" ];

  postInstallCheck = ''
    $out/bin/reno -h
  '';

  meta = with lib; {
    description = "Release Notes Manager";
    mainProgram = "reno";
    homepage = "https://docs.openstack.org/reno/latest";
    license = licenses.asl20;
    maintainers = teams.openstack.members ++ (with maintainers; [ drewrisinger guillaumekoenig ]);
  };
}
