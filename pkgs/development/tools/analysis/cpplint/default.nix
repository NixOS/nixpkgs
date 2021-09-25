{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "cpplint";
  version = "1.5.1";

  # Fetch from github instead of pypi, since the test cases are not in the pypi archive
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0k927mycj1k4l3fbxrk597bhcjl2nrpaas1imbjgk64cyq8dv7lh";
  };

  postPatch = ''
    patchShebangs cpplint_unittest.py
  '';

  checkInputs = with python3Packages; [ pytest pytest-runner ];
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
