{ lib, python3Packages, fetchFromGitHub, fetchpatch }:

python3Packages.buildPythonApplication rec {
  pname = "cpplint";
  version = "1.5.5";
  format = "setuptools";

  # Fetch from github instead of pypi, since the test cases are not in the pypi archive
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    hash = "sha256-JXz2Ufo7JSceZVqYwCRkuAsOR08znZlIUk8GCLAyiI4=";
  };

  patches = [
    ./0001-Remove-pytest-runner-version-pin.patch

    # The patch below stops using the sre_compile module, which was deprecated
    # in Python 3.11 and replaces it with re.compile. Upstream is unsure if it
    # should use re.compile or re._compiler.compile, so we should monitor the
    # thread for updates.
    #
    #   https://github.com/cpplint/cpplint/pull/214
    #
    (fetchpatch {
      name = "python-3.11-compatibility.patch";
      url = "https://github.com/cpplint/cpplint/commit/e84e84f53915ae2a9214e756cf89c573a73bbcd3.patch";
      hash = "sha256-u57AFWaVmGFSsvSGq1x9gZmTsuZPqXvTC7mTfyb2164=";
    })
  ];

  postPatch = ''
    patchShebangs cpplint_unittest.py
  '';

  nativeCheckInputs = with python3Packages; [ pytest pytest-runner ];
  checkPhase = ''
    ./cpplint_unittest.py
  '';

  meta = with lib; {
    homepage = "https://github.com/cpplint/cpplint";
    description = "Static code checker for C++";
    maintainers = [ maintainers.bhipple ];
    license = [ licenses.bsd3 ];
  };
}
