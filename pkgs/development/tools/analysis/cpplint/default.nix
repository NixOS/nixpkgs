{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "cpplint";
  version = "1.5.5";

  # Fetch from github instead of pypi, since the test cases are not in the pypi archive
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-JXz2Ufo7JSceZVqYwCRkuAsOR08znZlIUk8GCLAyiI4=";
  };

  patches = [ ./0001-Remove-pytest-runner-version-pin.patch ];

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
