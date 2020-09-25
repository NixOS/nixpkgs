{ lib, buildPythonApplication, fetchPypi, pynacl, GitPython, git-filter-repo}:

buildPythonApplication rec {
  pname = "gitprivacy";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1djrhyxssv44cyakjx1cvy3agif1b1jzd0kgf4wh3dgsbwa4x3nn";
  };

  propagatedBuildInputs = [
    git-filter-repo
    GitPython
    pynacl
  ];

  meta = with lib; {
    description = "Redact Git author and committer dates to keep committing behaviour more private.";
    license = licenses.bsd2;
    homepage = "https://github.com/EMPRI-DEVOPS/git-privacy";
    maintainers = with maintainers; [ ajs124 ];
  };
}
