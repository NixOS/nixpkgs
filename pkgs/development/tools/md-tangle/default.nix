{ lib, python3Packages, fetchFromGitHub }:

with python3Packages;

buildPythonApplication rec {
  pname = "md-tangle";
  version = "1.3.0";
  doCheck = false;

  src = fetchFromGitHub {
    owner = "joakimmj";
    repo = "md-tangle";
    rev = "v${version}";
    sha256 = "1xsqbq7kbgq5r050b07ixfn5v0w61a8nwd9d0vbbyjqgc8i6m6c6";
  };

  propagatedBuildInputs = [
    setuptools
  ];

  meta = with lib; {
    description = "Generates (\"tangles\") source code from Markdown documents";
    homepage = "https://github.com/joakimmj/md-tangle";
    license = licenses.mit;
    maintainers = with maintainers; [ michaelhthomas ];
  };
}
