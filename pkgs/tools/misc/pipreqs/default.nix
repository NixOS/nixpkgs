{ lib, python3 }:

with python3.pkgs;

buildPythonApplication rec {
  pname = "pipreqs";
  version = "0.4.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c793b4e147ac437871b3a962c5ce467e129c859ece5ba79aca83c20f4d9c3aef";
  };

  propagatedBuildInputs = [ yarg docopt ];

  # Tests requires network access. Works fine without sandboxing
  doCheck = false;

  meta = with lib; {
    description = "Generate requirements.txt file for any project based on imports";
    homepage = "https://github.com/bndr/pipreqs";
    license = licenses.asl20;
    maintainers = with maintainers; [ psyanticy ];
  };
}
