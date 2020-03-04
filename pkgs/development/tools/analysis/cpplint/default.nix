{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "cpplint";
  version = "1.3.0";

  # Fetch from github instead of pypi, since the test cases are not in the pypi archive
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "107v7bp35kxbv9v7wl79h7115z1m4b48rhasp0cnivql1grd277i";
  };

  postPatch = ''
    patchShebangs cpplint_unittest.py
  '';

  checkPhase = ''
    ./cpplint_unittest.py
  '';

  meta = with lib; {
    homepage = https://github.com/cpplint/cpplint;
    description = "Static code checker for C++";
    maintainers = [ maintainers.bhipple ];
    license = [ licenses.bsd3 ];
  };
}
