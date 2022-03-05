{ lib, python3Packages, fetchFromGitHub}:

python3Packages.buildPythonApplication rec {
  pname = "config-visualizer";
  version = "unstable-2022-02-23";

  src = fetchFromGitHub {
    owner = "precice";
    repo = pname;
    rev = "60f2165f25352c8261f370dc4ceb64a8b422d4ec";
    sha256 = "sha256:0mqzp2qdvbqbxaczlvc9xxxdz6hclraznbmc08ldx11xwy8yknfr";
  };

  propagatedBuildInputs = with python3Packages; [ lxml pydot ];
  doCheck = false;

  meta = with lib; {
    description = "Small python tool for visualizing the preCICE xml configuration ";
    homepage = "https://github.com/precice/config-visualizer";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
