{
  lib,
  fetchPypi,
  buildPythonPackage,
  execnet,
  pytest,
  setuptools-scm,
  pytest-forked,
  filelock,
  psutil,
  six,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "pytest-xdist";
  version = "1.34.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vh4ps32lp5ignch5adbl3pgchvigdfmrl6qpmhxih54wa1qw3il";
  };

  nativeBuildInputs = [
    setuptools-scm
    pytest
  ];
  nativeCheckInputs = [
    pytest
    filelock
  ];
  propagatedBuildInputs = [
    execnet
    pytest-forked
    psutil
    six
  ];

  # Encountered a memory leak
  # https://github.com/pytest-dev/pytest-xdist/issues/462
  doCheck = !isPy3k;

  checkPhase = ''
    # Excluded tests access file system
    py.test testing -k "not test_distribution_rsyncdirs_example \
                    and not test_rsync_popen_with_path \
                    and not test_popen_rsync_subdir \
                    and not test_init_rsync_roots \
                    and not test_rsyncignore"
  '';

  meta = with lib; {
    description = "py.test xdist plugin for distributed testing and loop-on-failing modes";
    homepage = "https://github.com/pytest-dev/pytest-xdist";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
