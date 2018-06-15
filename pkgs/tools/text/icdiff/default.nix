{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "icdiff-${version}";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "jeffkaufman";
    repo = "icdiff";
    rev = "release-${version}";
    sha256 = "0ffn5kq7dwvrimxgpj9ksym36c18md8nsdps82qzhm1xq7p9w9yb";
  };

  meta = with stdenv.lib; {
    homepage = https://www.jefftk.com/icdiff;
    description = "Side-by-side highlighted command line diffs";
    maintainers = with maintainers; [ aneeshusa ];
    license = licenses.psfl;
  };
}
