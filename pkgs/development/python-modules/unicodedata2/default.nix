{ lib, buildPythonPackage, fetchFromGitHub, pytest }:

buildPythonPackage rec {
  pname = "unicodedata2";
  version = "13.0.0-2";

  src = fetchFromGitHub {
    owner  = "mikekap";
    repo   = pname;
    rev    = version;
    sha256 = "0p9brbiwyg98q52y0gfyps52xv57fwqfpq0mn18p1xc1imip3h2b";
  };

  checkInputs = [ pytest ];
  checkPhase = "pytest tests";

  meta = with lib; {
    description = "Backport and updates for the unicodedata module";
    homepage = "https://github.com/mikekap/unicodedata2";
    license = licenses.asl20;
    maintainers = [ maintainers.sternenseemann ];
  };
}
