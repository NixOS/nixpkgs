{ lib, buildPythonPackage, fetchFromGitHub
, isPy3k, attrs, coverage, enum34, pexpect
, doCheck ? true, pytest, pytest-xdist, flaky, mock
, sortedcontainers
}:
buildPythonPackage rec {
  # https://hypothesis.readthedocs.org/en/latest/packaging.html

  # Hypothesis has optional dependencies on the following libraries
  # pytz fake_factory django numpy pytest
  # If you need these, you can just add them to your environment.

  version = "4.57.1";
  pname = "hypothesis";

  # Use github tarballs that includes tests
  src = fetchFromGitHub {
    owner = "HypothesisWorks";
    repo = "hypothesis-python";
    rev = "hypothesis-python-${version}";
    sha256 = "1qcpcrk6892hzyjsdr581pw6i4fj9035nv89mcjrcrzcmycdlfds";
  };

  postUnpack = "sourceRoot=$sourceRoot/hypothesis-python";

  propagatedBuildInputs = [
    attrs
    coverage
    sortedcontainers
  ] ++ lib.optional (!isPy3k) enum34;

  nativeCheckInputs = [ pytest pytest-xdist flaky mock pexpect ];
  inherit doCheck;

  checkPhase = ''
    rm tox.ini # This file changes how py.test runs and breaks it
    py.test tests/cover
  '';

  meta = with lib; {
    description = "Python library for property based testing";
    homepage = "https://github.com/HypothesisWorks/hypothesis";
    license = licenses.mpl20;
  };
}
